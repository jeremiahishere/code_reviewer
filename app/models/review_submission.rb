class ReviewSubmission < ActiveRecord::Base
  belongs_to :review

  validates_presence_of :review_id, :diff_text, :submission_date

  before_validation :get_diff_from_repo

  # Runs a fetch and pull on the projects repo
  # copies the repo into repos/project_id/submission_id/repo_name
  # checks out the branch and pulls
  # run a git diff and save the output
  def get_diff_from_repo
    # Runs a fetch and pull on the projects repo
    project.fetch_and_pull_trunk_repo
    # copies the repo into repos/project_id/submission_id/repo_name
    FileUtils.mkdir(submission_path) unless File.directory?(submission_path)
# this is the line with the error
    FileUtils.cp_r(project.trunk_repo_path, submission_repo_path)
    # checks out the branch and pulls
    checkout_and_pull_development_branch
    # run a git diff and save the output
    self.diff_text = diff_trunk_and_development
  end

  def project
    self.review.project
  end

  def development_branch
    self.review.development_branch
  end

  def submission_path
    project.project_path + "/" + self.id.to_s + "/"
  end

  def submission_repo_path
    submission_path + "/" + project.repo_name + "/"
  end

  def checkout_and_pull_development_branch
    `cd #{submission_repo_path} && git checkout #{self.development_branch} && git pull origin #{self.development_branch}`
  end

  def diff_trunk_and_development
    `cd #{submission_repo_path} && git dif #{self.project.trunk_branch}..#{self.development_branch}`
  end
end

