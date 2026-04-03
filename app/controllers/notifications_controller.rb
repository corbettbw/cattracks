class NotificationsController < ApplicationController
  def index
    @notifications = Current.user.notifications.recent.includes(:actor, :notifiable)
    @notifications.unread.update_all(read: true)
  end
end