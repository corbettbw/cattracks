class FeedbackMailer < ApplicationMailer
  default to: "feedback@cattracks.org"

  def feedback_email(name:, email:, message:, screenshots: nil)
    @name = name
    @email = email
    @message = message

    if screenshots.present?
      Array(screenshots).each do |screenshot|
        attachments[screenshot.original_filename] = screenshot.read
      end
    end
    
    mail(
      from: "noreply@cattracks.org",
      reply_to: email,
      subject: "Cat Tracks Feedback from #{name}"
    )
  end
end