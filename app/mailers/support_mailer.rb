class SupportMailer < ActionMailer::Base

  def support_enquiry(sender, subject, content)
    @content = content

    mail from: sender.email, to: 'info@hotspotting.com', subject: subject
  end
end
