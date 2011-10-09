# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_categories,:authorize

  def load_categories
    @categories = Category.all 
  end

  def authorize
    unless session[:login_user]
      redirect_to login_path, :alert => "请登录"
    end
  end
  
  def current_user
    User.find(session[:login_user].id)
  end
end
