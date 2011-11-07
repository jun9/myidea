# encoding: utf-8
class IdeasController < ApplicationController
  authorize_resource

  def index
  end
  
  def search
    search = Idea.search do
      keywords params[:q]
      paginate :page => params[:ideas_page],:per_page => Idea.per_page 
    end
    @ideas = search.results
    @total = search.total
    @query = params[:q]
    if request.xhr?
      render :partial => "search_tab",:locals => { :ideas => @ideas }
    end
  end

  def promotion
    @ideas=Idea.search do
      keywords params[:title]
      paginate :per_page => 20 
    end.results
    render :layout => false
  end
  
  def show
    if request.xhr?
      @comments = Comment.where(:idea_id => params[:id]).order("created_at asc").paginate(:page => params[:comments_page])
      render :partial => "comments",:locals => {:comments => @comments}
    else
      comments_page = session[:comments_page]?session[:comments_page]:params[:comments_page]
      session[:comments_page] = nil
      @categories = Category.all 
      @idea = Idea.find(params[:id])
      @comments = Comment.where(:idea_id => @idea.id).order("created_at asc").paginate(:page => comments_page)
      @comment = Comment.new
    end
  end

  def new
    @categories = Category.all 
    @idea = Idea.new
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    if @idea.save
      redirect_to @idea
    else
      render action: "new"
    end
  end

  def tab
    @categories = Category.all 
    cate_id = session[:cate_id]?session[:cate_id]:params[:cate_id]
    status = session[:status]?session[:stauts]:params[:status]
    session[:cate_id] = nil  
    session[:status] = nil  
    if request.xhr?
      conditions = {}
      unless cate_id.blank?
        conditions[:category_id] = cate_id 
        @category = Category.find(cate_id)
      end
      unless status.blank?
        @status = status
        conditions[:status] = status 
      end
      order = case 
      when params[:style] == "#{IDEA_SORT_HOT}" then "updated_at desc"
      when params[:style] == "#{IDEA_SORT_NEW}" then "created_at desc"
      when params[:style] == "#{IDEA_SORT_POINTS}" then "points desc"
      when params[:style] == "#{IDEA_SORT_COMMENTS}" then "comments_count desc"
      else "updated_at desc"
      end
      @ideas = Idea.where(conditions).paginate(:page => params[:ideas_page]).order(order)
      render :layout => false
    else
      session[:cate_id] = params[:cate_id]
      session[:status] = params[:status]
      render :action => :index
    end
  end

  def like
    idea = Idea.find(params[:id])
    idea.likers << current_user
    idea.update_attribute("points",idea.points+1)
    render :json => idea.to_json(:only => :points) 
  end
  
  def unlike
    idea = Idea.find(params[:id])
    idea.likers.delete(current_user)
    idea.update_attribute("points",idea.points-1)
    render :json => idea.to_json(:only => :points) 
  end

  def handle
    idea = Idea.find(params[:id])
    if idea.status
      status = idea.status + 1 unless idea.status == IDEA_STATUS_LAUNCHED
    else
      status = IDEA_STATUS_UNDER_REVIEW
    end
    idea.update_attribute("status",status)
    redirect_to idea
  end
end
