class Movie < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, styles: { medium: "400x600#", small: "175x300#" }, url: ":s3_domain_url"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end