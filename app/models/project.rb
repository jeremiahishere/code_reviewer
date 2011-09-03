class Project < ActiveRecord::Base
  has_many :project_members
  has_many :users, :through => :project_members
  has_many :reviews

  after_save :clone_and_pull_repo

  validates_presence_of :name, :repo_url, :repo_name

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
    FileUtils.mkdir(project_path) unless File.directory?(project_path)
    FileUtils.mkdir(trunk_path) unless File.directory?(trunk_path)

    clone_trunk_repo unless File.directory?(trunk_repo_path)
    fetch_and_pull_trunk_repo
  end

  def project_path
    Rails.root.to_s + "/repos/" + self.id.to_s
  end

  def trunk_path
    project_path + "/trunk/"
  end

  def trunk_repo_path
    trunk_path + "/" + self.repo_name + "/"
  end

  def clone_trunk_repo
    `cd #{trunk_path} && git clone #{self.repo_url} && git fetch`
  end

  def fetch_and_pull_trunk_repo
    `cd #{trunk_repo_path} && git fetch && git checkout #{self.trunk_branch} && git pull origin #{self.trunk_branch}`
  end
end
