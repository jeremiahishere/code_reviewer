class Project < ActiveRecord::Base
  has_many :project_members
  has_many :users, :through => :project_members
  has_many :reviews

  validates_presence_of :name, :repo_url

  # projects the users is a member of
  def self.member_projects(user)
    all.select{ |p| p.users.include?(user) }
  end

  def members
    self.users
  end
end
