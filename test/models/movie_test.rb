require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  def setup
    @movie = Movie.new(title: "Example Title", description: "Movie description")
  end

  test "title should not be blank" do
    @movie.title = ""
    assert_not @movie.valid?
  end

  test "title should not be too short" do
    @movie.title = "a" * 2
    assert_not @movie.valid?
  end

  test "description should not be blank" do
    @movie.description = "  "
    assert_not @movie.valid?
  end

  test "description should not be too short" do
    @movie.description = "a" * 4
    assert_not @movie.valid?
  end
end
