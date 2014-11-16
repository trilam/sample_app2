module SessionsHelper
 
  # Logs in the user
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
   

  # Return current log-in user 
  def current_user
    if (user_id = session[:user_id])
      @current_user || User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end   
  end

  # True if user is logged in.
  def logged_in?
    ! current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

     
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def redirect_back_or(default)
    if (session[:forwarding_url]) 
      redirect_to session[:forwarding_url]
      session.delete(:forwarding_url)
    else
      redirect_to default
    end
  end
end
