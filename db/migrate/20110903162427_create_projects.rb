class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :repo_url
      t.string :repo_name
      t.string :trunk_branch
      t.boolean :require_manager_approval, :default => false

      t.timestamps
    end
    create_table :project_members do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
    drop_table :project_users
  end
end
