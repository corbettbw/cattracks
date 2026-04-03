class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }

  after_create :notify_followed

  private

  def notify_followed
    followed.notify(actor: follower, notifiable: self, type: :new_follower)
  end
end