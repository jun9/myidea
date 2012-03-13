class PreferencesController < ApplicationController
  authorize_resource
  
  def dashboard
    if request.xhr?
      render :layout => false
    else
      render :layout => "admin"
    end
  end
 
  def index
    @preferences = Preference.all
    render :layout => false
  end
  
  def update
    @preference = Preference.find(params[:id])
    @preference.value = params[:value]
    @preference.save
  end
end
