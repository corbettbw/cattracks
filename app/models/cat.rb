class Cat < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :created_by_id, optional: true
  has_many :care_relationships, dependent: :destroy
  has_many :caregivers, through: :care_relationships, source: :user
  has_many :sightings, dependent: :destroy
  has_many :cat_tags, dependent: :destroy
  has_many :posts, through: :cat_tags
  has_one_attached :profile_photo
  has_many_attached :pictures

  scope :unclaimed, -> { where(created_by_id: nil) }

  validates :name, presence: true
end
