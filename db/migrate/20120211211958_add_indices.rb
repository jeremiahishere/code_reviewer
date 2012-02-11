class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :assignments, :role_id
    add_index :assignments, :user_id

    add_index :comments, :review_submission_id

    add_index :git_authors, :name

    add_index :git_commits, :project_id
    add_index :git_commits, :git_author_id

    add_index :project_members, :project_id
    add_index :project_members, :user_id

    add_index :projects, :name

    add_index :review_submissions, :review_id

    add_index :review_votes, :review_id

    add_index :reviews, :close_date

    add_index :roles, :name
  end

  def self.down
  end
end
