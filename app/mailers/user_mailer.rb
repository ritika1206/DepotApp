class UserMailer < ApplicationMailer
  default from: 'admin@depot.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to Depot App')
  end
end
