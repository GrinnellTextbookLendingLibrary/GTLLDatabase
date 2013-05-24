
module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def is_manager?
    current_user.manager?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end


  def authenticate_user
    deny_access unless signed_in?
  end

  def authenticate_manager
    deny_access unless is_manager?
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
