class MoviesController < ApplicationController
  #caches_page :index
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :fresh]

  attr_accessor :image_file_name

  def search
    if params[:search].present?
      @movies = Movie.search params[:search], fields: [:title]
      @movies_api = Tmdb::Movie.find(params[:search])
    else
      @movies = Movie.all
    end
  end

  def index
    @movies = Movie.order('cached_votes_score DESC', :id).page(params[:page]).per_page(32)
  end

  def fresh
    @movies = Movie.where("created_at > ?", 2.days.ago).order('cached_votes_score DESC').page(params[:page]).per_page(32)
  end

  def show
    #Future enhancement to show similar movies:
    #@similar = Tmdb::Movie.similar_movies(@movie.id)
    @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")
    if @reviews.blank?
      @avg_review = 0
    else
      @avg_review = @reviews.average(:rating)
    end
  end

  def new
    @movie = current_user.movies.build
  end

  def edit
  end

  def create
    #expire_page :action => :index
    @movie = current_user.movies.build(movie_params)
    @movie.image_from_url(params[:image_url])
    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def upvote
    @movie = Movie.find(params[:id])
    @movie.upvote_by current_user

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { count: @movie.votes_for.size } }
    end
  end
   
  def downvote
    @movie = Movie.find(params[:id])
    @movie.downvote_by current_user
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { count: @movie.votes_for.size } }
    end
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end
    def movie_params
      params.require(:movie).permit(:title, :description, :movie_length, :director, :rating, :image, :image_file_name, :page)
    end
end
