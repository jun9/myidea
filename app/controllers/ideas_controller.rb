# encoding: utf-8
class IdeasController < ApplicationController
  skip_before_filter :authorize,:only => [:index,:tab,:show,:search]

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
    session[:cate_id] = nil  
    if request.xhr?
      if cate_id && !cate_id.empty?
        @category = Category.find(cate_id)
        case params[:style]
        when '0'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:ideas_page]).order("updated_at desc")
        when '1'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:ideas_page]).order("created_at desc")
        when '2'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:ideas_page]).order("points desc")
        when '3'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:ideas_page]).order("comments_count desc")
        else
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:ideas_page]).order("updated_at desc")
        end
      else
        case params[:style]
        when '0'
          @ideas = Idea.paginate(:page => params[:ideas_page]).order("updated_at desc")
        when '1'
          @ideas = Idea.paginate(:page => params[:ideas_page]).order("created_at desc")
        when '2'
          @ideas = Idea.paginate(:page => params[:ideas_page]).order("points desc")
        when '3'
          @ideas = Idea.paginate(:page => params[:ideas_page]).order("comments_count desc")
        else
          @ideas = Idea.paginate(:page => params[:ideas_page]).order("updated_at desc")
        end
      end
      render :layout => false
    else
      session[:cate_id] = params[:cate_id]
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
end
