class CategoriesController < ApplicationController
  authorize_resource

  def index
    @categories = Category.all
    render :layout => false
  end
  
  def create
    @category=Category.new(:name => params[:name])
    @category.save
  end

  def destroy
    category = Category.find(params[:id])
    if category.destroy
      head :ok  
    else
      render :json => category.errors,:status => :unprocessable_entity
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.name = params[:name]
    @category.save
  end
end
