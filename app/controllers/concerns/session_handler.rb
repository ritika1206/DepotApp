module SessionHandler
  def log_in
    session[:user_id] = User.find_by(name: params[:name]).try(:id)
  end

  def log_out
    session[:user_id] = nil
    session[:hit_count] = nil
  end

  def user_registered?
    @logged_in_user = User.find_by(id: session[:user_id])
  end

  def user_logged_in?
    @logged_in_user
  end
end
