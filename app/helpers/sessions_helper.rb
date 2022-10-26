module SessionsHelper

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

    # Logs in the given user.
    def log_in(user)
      session[:user_id] = user.id
      # session[:session_token] = user.session_token
    end

    # Returns the current logged-in user (if any).
    def current_user
      if (user_id = session[:user_id])
        user = User.find_by(id: user_id)
        if user 
          # && session[:session_token] == user.session_token
          @current_user = user
        end
      elsif (user_id = cookies.encrypted[:user_id])
        user = User.find_by(id: user_id)
        if user 
          # && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
      !current_user.nil?
    end

    def log_out
      reset_session
      @current_user = nil
    end

     # Returns true if the given user is the current user.
    def current_user?(user)
      user && user == current_user
    end

    def store_location
      session[:forwarding_url] = request.original_url if request.get?
      puts "11111 #{session[:forwarding_url]}"
    end
end
