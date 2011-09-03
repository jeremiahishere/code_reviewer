class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :review_submissions do |t|
      t.integer :review_id
      t.text :diff_text
      t.datetime :submission_date
      t.text :reason

      t.timestamps
    end

    create_table :reviews do |t|
      t.integer :project_id
      t.integer :submitter_id
      t.string :trunk_branch
      t.string :development_branch
      t.date :close_date
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
    drop_table :review_submissions
  end
end
