class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :display_name, presence: true
  validates :zip_code, presence: true,
            format: {
              with: /\A\d{5}(-\d{4})?\z/,
              message: "must be a valid US zip code (e.g. 85020 or 85020-1234)"
            }
end
