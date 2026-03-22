class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :display_name, presence: true
  validates :zip_code, presence: true
end
