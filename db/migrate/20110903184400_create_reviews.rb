class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :project_id
      t.integer :submitter_id
      t.string :trunk_branch
      t.string :development_branch
      t.date :close_date

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
