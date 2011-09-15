class Project < ActiveRecord::Base
  has_many :project_members
  has_many :users, :through => :project_members
  has_many :reviews

  after_save :clone_and_pull_repo

  validates_presence_of :name, :repo_url, :repo_name

  default_scope :order => :name

  # projects the users is a member of
  def self.member_projects(user)
    all.select{ |p| p.users.include?(user) }
  end

  def members
    self.users
  end

  # creates a folder for the project in repos/id
  # checks out the trunk branch to be used for comparisons later
  def clone_and_pull_repo
    FileUtils.mkdir(project_path, :mode => 0744) unless File.directory?(project_path)

    clone_project_repo unless File.directory?(project_repo_path)
    fetch_and_pull_trunk
  end

  def project_path
    Rails.root.to_s + "/repos/" + self.id.to_s
  end

  def project_repo_path
    project_path + "/" + self.repo_name + "/"
  end

  def clone_project_repo
    `cd #{project_path} && git clone #{self.repo_url}`
  end

  def fetch_and_pull_trunk
    fetch_and_pull_branch(self.trunk_branch)
  end

  # fetch, checkout branch, pull branch, checkout trunk branch
  def fetch_and_pull_branch(branch_name)
    `cd #{project_repo_path} && git fetch && git checkout #{branch_name} && git pull origin #{branch_name} && git checkout #{self.trunk_branch}`
  end

  # runs a diff on the branch and trunk
  def diff_branch(branch_name)
    `cd #{project_repo_path} && git diff #{self.trunk_branch}..#{branch_name}`
  end

  # runs a diff on the branch and trunk with summary and stat options
  def diff_branch_summary(branch_name)
    `cd #{project_repo_path} && git diff #{self.trunk_branch}..#{branch_name} --summary --stat`
  end

  # this was put in place for an idea about listing branches in a dropdown instead of forcing users to put it in
  # strings need to be trimmed
  # frontend is not yet written
  #
  # may want to use -a
  def branch_list
    raw_branches = `cd #{project_repo_path} && git branch -r`
    branches = raw_branches.split(/\n/)
    return branches
  end
end
