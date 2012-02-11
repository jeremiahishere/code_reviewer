class GitCommit < ActiveRecord::Base
  belongs_to :project
  belongs_to :git_author

  validates_presence_of [:project_id, :git_author_id, :commit_hash, :subject, :commit_at]

  scope :committed_after, lambda { |start_time| where(["git_commits.commit_at >= ?", start_time]) }
  scope :by_project, lambda { |project| where(:project_id => project.id) }

  # @return [ActiveRecord::Relation] Commits on the project since the start time, recent ones first
  def self.recent_commits_by_project(project, start_time, limit)
    by_project(project).committed_after(start_time).includes(:git_author).order("git_commits.commit_at desc").limit(limit)
  end

  # @return [Number] Percentage of commits by an author on a project
  def self.contributors_by_project(project)
    commits = GitCommit.where(:project_id => project.id).includes(:git_author)
    commit_count = commits.length
    contributors = commits.collect(&:git_author).uniq

    output = []
    contributors.each do |author|
      author_commit_count = commits.select { |commit| commit.git_author == author }.count

      output << {
        :git_author => author,
        :num_commits => author_commit_count,
        :percentage_commits => '%.2f' % (100 * author_commit_count.to_f / commit_count.to_f)
      }
    end
    return output.sort { |a,b| b[:num_commits] <=> a[:num_commits] }
  end
end
