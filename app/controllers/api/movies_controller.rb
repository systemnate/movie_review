class Api::MoviesController < ApplicationController
  def index
    render json: Movie.all
  end
end