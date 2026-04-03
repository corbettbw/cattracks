class Sighting < ApplicationRecord
  belongs_to :cat
  belongs_to :user

  has_one_attached :photo


  validates :lat, presence: true
  validates :lng, presence: true

  after_create :generate_post
  before_create :set_zip_code

  after_create :notify_cat_followers

  after_create :check_sighting_scout

  
  private
  
  def check_sighting_scout
    if user.sightings.count >= 10
      user.award_badge("Sighting Scout")
    end
  end
  
  def notify_cat_followers
    cat.followers.each do |follower|
      follower.notify(actor: user, notifiable: self, type: :cat_sighting)
    end
  end

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