class SubmissionNotifier < ActionMailer::Base
  default :from => "info@codereviewer.com"

  def new_submission_notification(submission)
    @submission = submission
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:cc => recipients, :subject => "A code review has been requested for #{submission.project.name}")
  end

  def resubmission_notification(submission)
    @submission = submission
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:cc => recipients, :subject => "A code review has been submissionmitted for #{submission.project.name}")
  end

  def vote_notification(vote)
    @vote = vote
    mail(:cc => vote.review.submitter.email, :subject => "A vote has been cast on your review")
  end

  def comment_notification(comment)
    @comment = comment
    mail(:cc => comment.review_submission.review.submitter.email, :subject => "A comment has been added to your review")
  end

  def approval_notification(review)
    @review = review
    mail(:cc => review.submitter.email, :subject => "Your review has been approved")
  end
end
