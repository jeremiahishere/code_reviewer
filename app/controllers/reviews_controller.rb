class ReviewsController < ApplicationController
  load_and_authorize_resource
  # GET /reviews
  # GET /reviews.xml
  def index
    if params[:all] == 'y'
      @reviews = Review.all
    else
      @reviews = Review.member_reviews(current_user)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.xml
  def create
    @review = Review.new(params[:review])
    @review.submitter = current_user

    respond_to do |format|
      if @review.save
        @submission = ReviewSubmission.new(:review_id => @review.id, :submission_date => Time.now)
        if @submission.save
          format.html { redirect_to(@review, :notice => 'Review and Submission were successfully created.') }
        else
          format.html { redirect_to(@review, :notice => 'Review was successfully created but the submission was not.') }
        end
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.xml
  def update
    @review = Review.find(params[:id])
    @submission = ReviewSubmission.new(:review_id => @review.id, :submission_date => Time.now)

    respond_to do |format|
      if @review.update_attributes(params[:review])
        if @submission.save
          format.html { redirect_to(@review, :notice => 'Review and Submission were successfully created.') }
        else
          format.html { redirect_to(@review, :notice => 'Review was successfully created but the submission was not.') }
        end
        format.html { redirect_to(@review, :notice => 'Review was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.xml
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(reviews_url) }
      format.xml  { head :ok }
    end
  end

  def add_submission
    @review = Review.find(params[:id])
    @submission = ReviewSubmission.new(:review_id => @review.id, :submission_date => Time.now)
    respond_to do |format|
      if @submission.save
        format.html { redirect_to(reviews_url, :notice => "Submission created sucessfully") }
      else
        format.html { redirect_to(reviews_url, :notice => "Submission was not created successfully #{@submission.errors}") }
      end
    end
  end

  def review_submission
    @review = Review.find(params[:id])
    @submission = ReviewSubmission.where(:review_id => @review.id).order(:submission_date).last
    respond_to do |format|
      format.html # review.html.haml
    end
  end
end
