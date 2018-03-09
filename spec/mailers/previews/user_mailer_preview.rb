class UserMailerPreview < ActionMailer::Preview

  def reset_password_instructions
    UserMailer.reset_password_instructions(Admin.first, '0123456789')
  end

  def welcome_email
    UserMailer.welcome_email(Admin.first)
  end
end