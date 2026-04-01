class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create :initialize_profile

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :nullify
  has_many :sightings, dependent: :nullify
  has_many :care_relationships, dependent: :destroy
  has_many :cats, through: :care_relationships
  has_many :created_cats, class_name: "Cat", foreign_key: :created_by, dependent: :nullify

  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :follows, source: :followed

  has_many :reverse_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower
  
  has_many :cat_follows, dependent: :destroy
  has_many :followed_cats, through: :cat_follows, source: :cat
  
  private

  def initialize_profile
    profile = build_profile(
      display_name: email_address.split("@").first,
      zip_code: ""
    )
    profile.save(validate: false)
  end
end