# This class is parent of all controllers
# Functionality added to this class will be applicable to all controllers
class ApplicationController < ActionController::Base
  # This will be invoked beofre every action in controller
  before_action :authorize

  # By creating this method protected, it wont be exposed as public route
  protected def authorize
    unless @logged_in_user = User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end
end
