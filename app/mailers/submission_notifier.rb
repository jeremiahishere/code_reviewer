class SubmissionNotifier < ActionMailer::Base
  default :from => "notifications@cr.jeremiahhemphill.com"

  def new_submission_notification(submission)
    @submission = submission
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:to => recipients, :subject => "A code review has been submitted for #{submission.project.name} (#{submission.id.to_s})")
  end

  def resubmission_notification(submission)
    @submission = submission
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:to => recipients, :subject => "A code review has been resubmitted for #{submission.project.name} (#{submission.id.to_s})")
  end

  def vote_notification(vote)
    @vote = vote
    @submission = vote.review.last_submission
    mail(:to => vote.review.submitter.email, :subject => "A vote has been cast on your review (#{@submission.id.to_s})")
  end

  def comment_notification(comment)
    @comment = comment
    @submission = comment.review_submission
    mail(:to => comment.review_submission.review.submitter.email, :subject => "A comment has been added to your review (#{@submission.id.to_s})")
  end

  def approval_notification(review)
    @review = review
    @submission = review.last_submission
    mail(:to => review.submitter.email, :subject => "Your review has been approved (#{@submission.id.to_s})")
  end
end
