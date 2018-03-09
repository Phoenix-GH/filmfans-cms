class UserMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def welcome_email(resource)
    @resource = resource

    mail from: ENV['DEVISE_MAILER_SENDER'],
      to: @resource.email,
      subject: 'Welcome to HotSpotting'
  end
end
