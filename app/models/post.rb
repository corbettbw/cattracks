class Post < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :sighting, optional: true
  belongs_to :parent, class_name: "Post", optional: true
  has_many :replies, class_name: "Post", foreign_key: :parent_id, dependent: :destroy

  has_many :cat_tags, dependent: :destroy
  has_many :cats, through: :cat_tags
  has_many :user_tags, dependent: :destroy
  has_many :tagged_users, through: :user_tags, source: :tagged_user
  has_many_attached :photos

  enum :post_type, { microblog: 0, sighting: 1, new_cat: 2 }

  scope :top_level, -> { where(parent_id: nil) }

  validates :body, presence: true
  validates :post_type, presence: true
end