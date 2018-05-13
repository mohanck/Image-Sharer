module SessionsHelper
  def create_session(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user = User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user
        create_session(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
  end

  def forget
    cookies.delete(:user_id)
  end
end
