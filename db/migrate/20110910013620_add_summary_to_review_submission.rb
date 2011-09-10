class AddSummaryToReviewSubmission < ActiveRecord::Migration
  def self.up
    add_column :review_submissions, :diff_summary, :text
  end

  def self.down
    remove_column :review_submissions, :diff_summary
  end
end
