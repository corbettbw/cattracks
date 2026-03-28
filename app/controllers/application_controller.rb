class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_complete_profile
  
  private

  def require_complete_profile
    return unless authenticated?
    return if profile_complete?
    return if controller_name.in?(%w[profiles sessions passwords users])
    redirect_to edit_profile_path, alert: "Please complete your profile before continuing."
  end

  def profile_complete?
    profile = Current.user.profile
    profile.present? && profile.display_name.present? && profile.zip_code.present?
  end
end
