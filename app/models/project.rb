class Project < ActiveRecord::Base
  has_many :project_members
  has_many :users, :through => :project_members
  has_many :reviews

  after_save :create_repo_folder

  validates_presence_of :name, :repo_url

  # projects the users is a member of
  def self.member_projects(user)
    all.select{ |p| p.users.include?(user) }
  end

  def members
    self.users
  end

  # creates a folder for the project in repos/id
  def create_repo_folder
    path = Rails.root.to_s + "/repos/" + self.id.to_s
    FileUtils.mkdir(path) unless File.directory? path 
  end
end
