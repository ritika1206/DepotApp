# This class is parent of all controllers
# Functionality added to this class will be applicable to all controllers
class ApplicationController < ActionController::Base
  # This will be invoked beofre every action in controller
  before_action :authorize
  before_action :increment_hit_counter
  around_action :action_response_time

  # By creating this method protected, it wont be exposed as public route
  protected def authorize
    unless @logged_in_user = User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end

  private
    def increment_hit_counter
      @logged_in_user = User.find_by(id: session[:user_id])
      @logged_in_user.increment! :hit_count
    end

    def action_response_time
      t = Time.now
      yield
      @action_response_time = (Time.now - t)*1000
      response.set_header 'Action_Response_Time', @action_response_time
    end
end
