class ReviewVote < ActiveRecord::Base
  belongs_to :review
  belongs_to :user

  validates_presence_of :review_id, :user_id, :vote

  VOTES = { :reject => -1, :no_opinion => 0, :accept => 1 }
  
  def self.allowable_votes
    VOTES
  end

  # refactor
  def display_vote
    return "Reject" if self.vote == -1
    return "No Opinion" if self.vote == 0
    return "Accept" if self.vote == 1
  end
end
