class CreateReviewVotes < ActiveRecord::Migration
  def self.up
    create_table :review_votes do |t|
      t.integer :review_id
      t.integer :user_id
      t.integer :vote

      t.timestamps
    end
  end

  def self.down
    drop_table :review_votes
  end
end
