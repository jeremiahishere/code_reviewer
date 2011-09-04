class ReviewSubmission < ActiveRecord::Base
  belongs_to :review

  validates_presence_of :review_id, :diff_text, :submission_date

  before_validation :get_diff_from_repo
  after_save :reset_all_votes

  # pull master
  # pull our branch
  # run a diff
  def get_diff_from_repo
    project.fetch_and_pull_trunk
    project.fetch_and_pull_branch(development_branch)
    self.diff_text = project.diff_branch(development_branch)
  end

  # when a submission is created, set all votes to no opinion
  # on a resubmission, the content should change requiring new votes
  def reset_all_votes
    self.review.votes.each do |vote|
      vote.vote = ReviewVote.allowable_votes[:no_opinion]
      vote.save
    end
  end

  def project
    self.review.project
  end

  def development_branch
    self.review.development_branch
  end
end
