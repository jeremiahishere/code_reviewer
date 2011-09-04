class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :review_submission_id
      t.integer :user_id
      t.datetime :post_date
      t.integer :parent_comment_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
