class GitAuthor < ActiveRecord::Base
  has_many :git_commits

  validates_presence_of [:name]


end
