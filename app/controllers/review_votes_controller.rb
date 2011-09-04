class ReviewVotesController < ApplicationController
  load_and_authorize_resource

  def vote
    @vote = ReviewVote.find_or_create_by_id(params[:id])
    @vote.attributes = params[:review_vote]

    respond_to do |format|
      if @vote.save
        format.html { redirect_to(reviews_url, :notice => "Your vote was succsefully cast.")}
      else
        format.html { redirect_to(reviews_url, :notice => "Your vote was not succsefully cast.")}
      end
    end
  end
end
