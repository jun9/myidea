class DashboardController < ApplicationController
  def index
    if request.xhr?
      render :layout => false
    else
      render :layout => "admin"
    end
  end
end
