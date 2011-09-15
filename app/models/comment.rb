# Comments for the review submission
#
# Includes support for nesting comments but I am not plannning on adding it for now
class Comment < ActiveRecord::Base
  belongs_to :review_submission
  belongs_to :user

  validates_presence_of :review_submission_id, :user_id, :post_date, :comment

  default_scope :order => :post_date

  def review
    self.review_submission.review
  end
end
