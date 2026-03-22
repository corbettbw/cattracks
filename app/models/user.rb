class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :nullify
  has_many :sightings, dependent: :nullify
  has_many :care_relationships, dependent: :destroy
  has_many :cats, through: :care_relationships
  has_many :created_cats, class_name: "Cat", foreign_key: :created_by_id, dependent: :nullify
end