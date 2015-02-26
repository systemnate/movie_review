class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  Tmdb::Api.key("1f871e9190e9043245fbe0763fb774a4")
end
