module SubmissionNotifierHelper
  def review_number(review, submission)
    "(" + review.id.to_s + "." + submission.id.to_s + ")"
  end
end
