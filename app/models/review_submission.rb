class ReviewSubmission < ActiveRecord::Base
  belongs_to :review

  validates_presence_of :review_id, :diff_text, :submission_date
end
