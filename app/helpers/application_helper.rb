module ApplicationHelper

  def sign_in(manager)
    cookies.permanent.signed[:remember_token] = [manager.id, manager.salt]
    self.current_manager = manager
  end

end
