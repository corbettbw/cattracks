class Sighting < ApplicationRecord
  belongs_to :cat
  belongs_to :user

  validates :lat, presence: true
  validates :lng, presence: true

  after_create :generate_post

  private

  def generate_post
    post = user.posts.create!(
      body: "Spotted #{cat.name}!",
      post_type: :sighting
    )
    post.cat_tags.create!(cat: cat)
  end
end