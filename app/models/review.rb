class Review < ActiveRecord::Base
  belongs_to :project
  belongs_to :submitter, :foreign_key => :submitter_id, :class_name => "User"
  has_many :review_submissions

  validates_presence_of :project, :submitter, :development_branch

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
end
