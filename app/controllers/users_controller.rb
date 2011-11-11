# encoding: utf-8
class UsersController < ApplicationController
  authorize_resource 

  def login
    if request.post?
      if user = User.authenticate(params[:username],params[:password])
        session[:login_user] = LoginUser.new(user)
        redirect_to ideas_path
      else
        flash.now[:alert] = "登录失败，账号或密码错误"
      end
    end
  end

  def logout
    session[:login_user] = nil 
    redirect_to ideas_path
  end
end
