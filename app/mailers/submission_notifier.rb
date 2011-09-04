class SubmissionNotifier < ActionMailer::Base
  default :from => "info@codereviewer.com"

  def new_submission_notification(submission)
    @submission = submission
    recipients = submission.project.membger_emails | User.manager_emails
    mail(:recpieints => recipients, :subject => "A code review has been requested for #{submission.project.name}")
  end

  def resubmission_notification(resub)
    @submission = submission
    recipients = submission.project.membger_emails | User.manager_emails
    mail(:recpieints => recipients, :subject => "A code review has been resubmitted for #{submission.project.name}")
  end

  def vote_notification(vote)
  end

  def comment_notification(comment)
  end

  def approval_notification(review)

end
