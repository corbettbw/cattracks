class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  enum :notification_type, {
    new_follower: 0,
    post_reply: 1,
    mention: 2,
    cat_sighting: 3
  }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(50) }

  def mark_read!
    update(read: true)
  end
end