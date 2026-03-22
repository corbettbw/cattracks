class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cat_tags, dependent: :destroy
  has_many :cats, through: :cat_tags
  has_many :user_tags, dependent: :destroy
  has_many :tagged_users, through: :user_tags, source: :tagged_user
  has_many_attached :photos

  enum :post_type, { microblog: 0, sighting: 1 }

  validates :body, presence: true
  validates :post_type, presence: true
end
