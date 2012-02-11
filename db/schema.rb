# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120211211958) do

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "review_submission_id"
    t.integer  "user_id"
    t.datetime "post_date"
    t.integer  "parent_comment_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["review_submission_id"], :name => "index_comments_on_review_submission_id"

  create_table "git_authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "git_authors", ["name"], :name => "index_git_authors_on_name"

  create_table "git_commits", :force => true do |t|
    t.integer  "project_id"
    t.integer  "git_author_id"
    t.string   "commit_hash"
    t.text     "subject"
    t.datetime "commit_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "git_commits", ["git_author_id"], :name => "index_git_commits_on_git_author_id"
  add_index "git_commits", ["project_id"], :name => "index_git_commits_on_project_id"

  create_table "project_members", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_members", ["project_id"], :name => "index_project_members_on_project_id"
  add_index "project_members", ["user_id"], :name => "index_project_members_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "repo_url"
    t.string   "repo_name"
    t.string   "trunk_branch"
    t.boolean  "require_manager_approval", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "review_submissions", :force => true do |t|
    t.integer  "review_id"
    t.text     "diff_text"
    t.datetime "submission_date"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "diff_summary"
  end

  add_index "review_submissions", ["review_id"], :name => "index_review_submissions_on_review_id"

  create_table "review_votes", :force => true do |t|
    t.integer  "review_id"
    t.integer  "user_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_votes", ["review_id"], :name => "index_review_votes_on_review_id"

  create_table "reviews", :force => true do |t|
    t.integer  "project_id"
    t.integer  "submitter_id"
    t.string   "development_branch"
    t.date     "close_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["close_date"], :name => "index_reviews_on_close_date"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
