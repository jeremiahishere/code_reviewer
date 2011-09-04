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
      ReviewVote.create(:review_id => self.id, :user_id => member.id, :vote => ReviewVote.allowable_votes[:no_opinion])
    end
  end

  def self.member_reviews(user)
    all.select { |r| r.project.members.include?(user) }
  end

  scope :active, lambda { where(["close_date is not null"]) }
  scope :closed, lambda { where(["close_date is null"]) }

  def closed?
    return !self.close_date.nil?
  end

  def has_submissions?
    return self.review_submissions.length > 0
  end

  def votes
    self.review_votes
  end
end
