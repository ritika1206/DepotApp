class UserMailer < ApplicationMailer
  default from: SENDER_EMAIL

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Depot App')
  end
end
