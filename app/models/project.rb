class Project < ActiveRecord::Base
  has_many :project_members
  has_many :users, :through => :project_members

  validates_presence_of :name, :repo_url, :require_manager_approval

  # projects the users is a member of
  def self.member_projects(user)
    all.select( |p| p.users.include?(user) }
  end
end
