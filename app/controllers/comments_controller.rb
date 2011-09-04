class CommentsController < ApplicationController
  load_and_authorize_resource
  
  def add_comment
    @comment = Comment.new(params[:comment])
    @comment.post_date = Time.now
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(reviews_url, :notice => "Comment added succesfully")}
      else
        format.html { redirect_to(reviews_url, :notice => "Comment not added succesfully")}
      end
    end
  end
end
