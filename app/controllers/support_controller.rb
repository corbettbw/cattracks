class SupportController < ApplicationController
  skip_before_action :require_complete_profile

  def index
    @stripe_configured = ENV["STRIPE_PUBLISHABLE_KEY"].present?
  end

  def feedback
    name = params[:name]
    email = params[:email]
    message = params[:message]
    screenshots = params[:screenshots]


    if name.blank? || email.blank? || message.blank?
      flash[:alert] = "Please fill in all fields."
      redirect_to support_path
      return
    end

    if ENV["SMTP_HOST"].present?
      FeedbackMailer.feedback_email(
        name: name,
        email: email,
        message: message,
        screenshots: screenshots
      ).deliver_later
      flash[:notice] = "Thanks for your feedback! We'll be in touch."
    else
      Rails.logger.info "FEEDBACK (email not configured): #{name} <#{email}> — #{message}"
      flash[:notice] = "Thanks for your feedback! (Email delivery not yet configured)"
    end

    redirect_to support_path
  end
end