class Review < ActiveRecord::Base
  belongs_to :project
  belongs_to :submitter, :foreign_key => :submitter_id, :class_name => "User"
  has_many :review_submissions
  has_many :review_votes

  after_save :create_votes

  validates_presence_of :project, :submitter, :development_branch

  # when a review is created, create votes for all of the members of the project
  # and set them to no opinion
  def create_votes
    self.project.members.each do |member|
      if ReviewVote.where(:review_id => self.id, :user_id => member.id).length == 0
        ReviewVote.create(:review_id => self.id, :user_id => member.id, :vote => ReviewVote.allowable_votes[:no_opinion])
      end
    end
  end

  def self.member_reviews(user)
    all.select { |r| r.project.members.include?(user) }
  end

  scope :closed, lambda { where(["close_date is not null"]) }
  scope :active, lambda { where(["close_date is null"]) }

  def closed?
    return !self.close_date.nil?
  end

  def has_submissions?
    return self.review_submissions.length > 0
  end

  def votes
    self.review_votes
  end

  # determines if the review has been approved
  # returns true if the number of acepting member votes matches the number of members
  # and returns true if it has at least one accepting manager vote and requires a manager vote
  def approved?
    meets_approval_requirements = true
    meets_approval_requirements = false if member_votes < member_votes_needed
    meets_approval_requirements = false if(manager_votes < manager_votes_needed && self.project.require_manager_approval)
    return meets_approval_requirements
  end

  # number of votes from members
  def member_votes
    member_votes = 0
    self.votes.each do |vote|
      if self.project.members.include?(vote.user)
        member_votes += vote.vote
      end
    end
    return member_votes
  end

  # number of votes from memebers needed
  def member_votes_needed
    return self.project.members.length
  end

  # number of votes from managers who are not members
  def manager_votes
    manager_votes = 0
    self.votes.each do |vote|
      # managers who are not members
      if !self.project.members.include?(vote.user) && vote.user.has_role?(:manager)
        manager_votes += vote.vote
      end
    end
    return manager_votes
  end

  def manager_votes_needed
    if self.project.require_manager_approval
      return 1
    else
      return 0
    end
  end

  # a list of all comments from all submissions
  def comments
    comments = []
    self.review_submissions.each do |submission|
      submission.comments.each do |comment|
        comments.push(comment)
      end
    end
    return comments
  end
end
