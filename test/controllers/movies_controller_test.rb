require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @user = User.new(email: "example@example.com", password: "password", password_confirmation: "password")
    @user.save
    sign_in @user
    @movie = Movie.new(title: "Title", description: "Description", director: "Nate Dalo", movie_length: "60")
    @movie.save
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post :create, movie: { title: "new movie title", description: "new movie description" }
    end
    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should show movie" do
    get :show, id: @movie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie
    assert_response :success
  end

  test "should update movie" do
    patch :update, id: @movie, movie: { description: @movie.description, director: @movie.director, movie_length: @movie.movie_length, rating: @movie.rating, title: @movie.title }
    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete :destroy, id: @movie
    end
    assert_redirected_to movies_path
  end
end