class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def current_user
    if(session[:login_user])
      User.find(session[:login_user].id)
    end
  end
end
