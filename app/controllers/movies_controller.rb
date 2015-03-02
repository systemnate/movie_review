class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  attr_accessor :image_file_name

  def search
    if params[:search].present?
      @movies = Movie.search(params[:search])
      @movies_api = Tmdb::Movie.find(params[:search])
    else
      @movies = Movie.all
    end
  end

  def index
    @movies = Movie.paginate(page: params[:page], per_page: 32).order('cached_weighted_average DESC')

    #@movies = Movie.all.order('cached_votes_up DESC')
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
    redirect_to :back
  end
   
  def downvote
    @movie = Movie.find(params[:id])
    @movie.downvote_by current_user
    redirect_to :back
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end
    def movie_params
      params.require(:movie).permit(:title, :description, :movie_length, :director, :rating, :image, :image_file_name)
    end
end
