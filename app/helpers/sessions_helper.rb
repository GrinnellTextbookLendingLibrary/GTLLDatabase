
module SessionsHelper
  def sign_in(manager)
    cookies.permanent.signed[:remember_token] = [manager.id, manager.salt]
    self.current_manager = manager
  end

  def current_manager=(manager)
    @current_manager = manager
  end

  def current_manager
    @current_manager ||= manager_from_remember_token
  end

  def signed_in?
    !current_manager.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_manager = nil
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end


  def authenticate
    deny_access unless signed_in?
  end

  private

    def manager_from_remember_token
      Manager.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
