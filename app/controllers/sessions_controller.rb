class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])

    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:user_last_active_at] = Time.now
      if user.role == 'admin'
        redirect_to admin_reports_path
      else
        redirect_to store_index_url
      end
    else
      redirect_to login_url, alert: t('invalid_combination')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: t('logged_out')
  end
end
