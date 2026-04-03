class WebhooksController < ApplicationController
  skip_before_action :require_authentication
  skip_before_action :require_complete_profile
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    webhook_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    if webhook_secret.present?
      begin
        event = Stripe::Event.construct_from(JSON.parse(payload))
        # Uncomment when Stripe gem is added:
        # event = Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
      rescue JSON::ParserError
        render json: { error: "Invalid payload" }, status: 400
        return
      end
    else
      Rails.logger.warn "Stripe webhook secret not configured — skipping signature verification"
      event = JSON.parse(payload, symbolize_names: true)
      render json: { received: true }, status: 200
      return
    end

    if event[:type] == "checkout.session.completed"
      session = event[:data][:object]
      user_id = session[:metadata][:user_id]
      user = User.find_by(id: user_id)
      user&.award_badge("Early Backer")
    end

    render json: { received: true }, status: 200
  end
end