class CreateGitAuthorsAndCommits < ActiveRecord::Migration
  def self.up
    create_table :git_authors do |t|
      t.string :name

      t.timestamps
    end

    create_table :git_commits do |t|
      t.integer :project_id
      t.integer :git_author_id
      t.string :commit_hash
      t.text :subject
      t.datetime :commit_at

      t.timestamps
    end
  end

  def self.down
    drop_table :git_authors
    drop_table :git_commits
  end
end
