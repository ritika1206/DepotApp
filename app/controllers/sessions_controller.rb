class SessionsController < ApplicationController
  include SessionHandler

  skip_before_action :authorize
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    
    if user.try(:authenticate, params[:password])
      log_in
      session[:user_last_active_at] = Time.now
      if user.admin?
        redirect_to admin_reports_path
      else
        redirect_to store_index_url
      end
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    log_out
    redirect_to store_index_url, notice: "Logged out"
  end
end
