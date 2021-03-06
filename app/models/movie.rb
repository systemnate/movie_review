require 'open-uri'

class Movie < ActiveRecord::Base
  searchkick
  acts_as_votable
  belongs_to :user
  has_many :reviews
  has_attached_file :image, styles: { medium: "400x600#", small: "175x300#" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :title,  presence: true, length: { minimum: 3, maximum: 75 }, uniqueness: { case_sensitive: false }
  validates :description,  presence: true, length: { minimum: 5, maximum: 1000 }
  def image_from_url(url)
    self.image = open(URI.parse(url))
  rescue
  end

  def score
    self.get_upvotes.size - self.get_downvotes.size
  end
end