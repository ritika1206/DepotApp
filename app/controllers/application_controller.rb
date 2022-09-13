class ApplicationController < ActionController::Base
  before_action :only_access_home_page
  before_action :authorize
  before_action :auto_logout_user_on_inactivity
  before_action :increment_hit_counter
  around_action :action_response_time

  protected def authorize
    p request.headers['User-Agent'] =~ /chrome/i
    unless @logged_in_user = User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end

  private
    def increment_hit_counter
      if @logged_in_user
        @logged_in_user = User.find_by(id: session[:user_id])
        @logged_in_user.increment! :hit_count
      end
    end

    def action_response_time
      t = Time.now
      yield
      @action_response_time = (Time.now - t)*1000
      response.set_header 'Action_Response_Time', @action_response_time
    end

    def auto_logout_user_on_inactivity
      if session[:user_id] && (Time.now - session[:user_last_active_at].to_time) >= 5.minutes
        session[:user_id] = nil
        redirect_to store_index_url, notice: "Logged out"
      else
        session[:user_last_active_at] = Time.now
      end
    end

    def only_access_home_page
      if request.headers['User-Agent'] =~ /chrome/i
        @products = Product.all
        render template: 'store/index'
      end
    end
end
