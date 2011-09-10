class PagesController < ApplicationController

  def index
    if current_user
      @pending_reviews = current_user.pending_reviews
    end
  end
end
