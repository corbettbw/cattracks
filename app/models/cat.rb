class Cat < ApplicationRecord
    belongs_to :creator, class_name: "User", foreign_key: :created_by, optional: true 
    scope :unclaimed, -> { where(created_by: nil) }
    has_many :care_relationships, dependent: :destroy
    has_many :caregivers, through: :care_relationships, source: :user
    has_many :sightings, dependent: :destroy
    has_many :cat_tags, dependent: :destroy
    has_many :posts, through: :cat_tags
    
    has_many :cat_follows, dependent: :destroy
    has_many :followers, through: :cat_follows, source: :user

    has_one_attached :profile_photo
    has_many_attached :pictures

    scope :unclaimed, -> { where(created_by: nil) }

    validates :name, presence: true
    after_create :generate_post

    private

    def generate_post
        return unless creator
        post = creator.posts.create!(
        body: "#{creator.profile&.display_name || "Someone"} added #{name} to Cat Tracks!",
        post_type: :new_cat
        )
        post.cat_tags.create!(cat: self)

        if profile_photo.attached?
            post.photos.attach(profile_photo.blob)
        end
    end
end
