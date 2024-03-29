class SubmissionNotifier < ActionMailer::Base
  include SubmissionNotifierHelper

  default :from => "notifications@cr.jeremiahhemphill.com"

  def new_submission_notification(submission)
    @submission = submission
    @review = submission.review
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:to => recipients, :subject => "A code review has been submitted for #{submission.project.name} #{review_number(@review, @submission)}")
  end

  def resubmission_notification(submission)
    @submission = submission
    @review = submission.review
    recipients = submission.project.members.collect { |m| m.email } | User.managers.collect { |m| m.email }
    mail(:to => recipients, :subject => "A code review has been resubmitted for #{submission.project.name} #{review_number(@review, @submission)}")
  end

  def vote_notification(vote)
    @vote = vote
    @submission = vote.review.last_submission
    @review = vote.review
    mail(:to => vote.review.submitter.email, :subject => "A vote has been cast on your review #{review_number(@review, @submission)}")
  end

  def comment_notification(comment)
    @comment = comment
    @submission = comment.review_submission
    @review = @submission.review
    review_submitter = comment.review_submission.review.submitter.email
    # this gets everyone who has commented on the review
    # it is a potentially temporary method that will not be needed
    # when comment trees are added
    commenters = comment.review.comments.collect {|c| c.user.email }

    emailees = commenters | [review_submitter]
    mail(:to => emailees, :subject => "A comment has been added to your review #{review_number(@review, @submission)}")
  end

  def approval_notification(review)
    @review = review
    @submission = review.last_submission
    mail(:to => review.submitter.email, :subject => "Your review has been approved (#{review_number(@review, @submission)}")
  end
end
