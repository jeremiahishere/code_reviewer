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

  # updates the commit history for the trunk branch
  def update_commit_history
    raw_commits = `cd #{project_repo_path} && git fetch && git checkout #{self.trunk_branch} && git log --pretty='%H -::- %an -::- %s -::- %ai'`
    raw_commits.each do |raw_commit|
      # commit format
      # 0 => hash
      # 1 => author name
      # 2 => commit message
      # 3 => commit date
      commit = raw_commit.split("-::-")
      commit.collect!(&:strip)
      # avoid issues with git log header and footer information 
      if commit.count == 4
        author = GitAuthor.find_or_create_by_name(commit[1])
        # note that this breaks if two projects manage to get the same hash
        obj = GitCommit.find_by_commit_hash(commit[0])
        attributes = {
          :commit_hash => commit[0],
          :project => self, 
          :git_author => author, 
          :subject => commit[2], 
          :commit_at => Time.parse(commit[3])
        }
        if obj.nil?
          GitCommit.create!(attributes)
        else
          # for now, assume you cannot update a commit
          # makes this run much faster
          # obj.attributes = attriubtes
          # obj.save!
        end
      end
    end
  end
end
