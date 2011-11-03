# encoding: utf-8
class UsersController < ApplicationController
  authorize_resource 

  def new
  end

  def create
    if user = User.authenticate(params[:username],params[:password])
      session[:login_user] = LoginUser.new(user)
      redirect_to ideas_path
    else
      redirect_to login_path,:alert => "登录失败，账号或密码错误"
    end
  end

  def destroy
    session[:login_user] = nil 
    redirect_to ideas_path
  end
end
