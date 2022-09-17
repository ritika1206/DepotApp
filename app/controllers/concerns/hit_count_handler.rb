module HitCountHandler
  def increment_session_hit_count
    if user_logged_in?
      session[:hit_count] ||= 0
      session[:hit_count] += 1
    end
  end

  def increment_user_hit_count
    if user_logged_in?
      @logged_in_user.increment! :hit_count
    end
  end
end
