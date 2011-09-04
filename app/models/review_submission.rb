class ReviewSubmission < ActiveRecord::Base
  belongs_to :review

  validates_presence_of :review_id, :diff_text, :submission_date

  before_validation :get_diff_from_repo

  # pull master
  # pull our branch
  # run a diff
  def get_diff_from_repo
    project.fetch_and_pull_trunk
    project.fetch_and_pull_branch(development_branch)
    self.diff_text = project.diff_branch(development_branch)
  end

  def project
    self.review.project
  end

  def development_branch
    self.review.development_branch
  end
end
