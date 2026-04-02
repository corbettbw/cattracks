class Sighting < ApplicationRecord
  belongs_to :cat
  belongs_to :user

  has_one_attached :photo


  validates :lat, presence: true
  validates :lng, presence: true

  after_create :generate_post
  before_create :set_zip_code

  private
  
  def set_zip_code
    results = Geocoder.search([lat, lng])
    self.zip_code = results.first&.postal_code
  end

  def generate_post
    post = user.posts.create!(
      body: "Spotted #{cat.name}!",
      post_type: :sighting,
      sighting_id: self.id
    )
    post.cat_tags.create!(cat: cat)
  end
end