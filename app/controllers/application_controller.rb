class ApplicationController < ActionController::Base
  include SessionHandler
  include HitCountHandler

  before_action :authorize
  before_action :auto_logout_user_on_inactivity
  before_action :increment_user_hit_count
  before_action :increment_session_hit_count
  around_action :evaluate_action_response_time

  protected def authorize
    unless user_registered?
      redirect_to login_url, notice: "Please log in"
    end
  end

  private

  def evaluate_action_response_time
    t = Time.now
    yield
    @action_response_time = (Time.now - t)*1000
    response.set_header 'Action_Response_Time', @action_response_time
  end

  def auto_logout_user_on_inactivity
    if user_logged_in? && (Time.now - session[:user_last_active_at].to_time) >= 5.minutes
      log_out
      redirect_to store_index_url, notice: "Logged out"
    else
      session[:user_last_active_at] = Time.now
    end
  end
end
