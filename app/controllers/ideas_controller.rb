class IdeasController < ApplicationController
  authorize_resource

  def index
    @ideas = Idea.includes(:tags,:user)
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
      @comments = Comment.where(:idea_id => params[:id]).order("created_at asc").paginate(:page => params[:comments_page]).includes(:user)
      render :partial => "comments",:locals => {:comments => @comments}
    else
      comments_page = session[:comments_page]?session[:comments_page]:params[:comments_page]
      session[:comments_page] = nil
      @idea = Idea.find(params[:id])
      @comments = Comment.where(:idea_id => @idea.id).order("created_at asc").paginate(:page => comments_page).includes(:user)
      @comment = Comment.new
      @solution = Solution.new
      @user = User.new
    end
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    if @idea.save
      redirect_to @idea
    else
      render action: 'new'
    end
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])
    @idea.category_id = params[:cate][:id]
    if @idea.save
      redirect_to @idea
    else
      render action: 'edit'
    end
  end

  def handle
    @idea = Idea.find(params[:id])
    if request.post?
      if @idea.change_status
        redirect_to @idea
      end
    end
  end

  def tab
    cate_id = params[:cate_id]
    status = params[:status]
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
      when params[:style] == "#{IDEA_SORT_HOT}" then "MONTH(created_at) desc,(points+comments_count) desc"
      when params[:style] == "#{IDEA_SORT_NEW}" then "created_at desc"
      when params[:style] == "#{IDEA_SORT_POINTS}" then "points desc"
      when params[:style] == "#{IDEA_SORT_COMMENTS}" then "comments_count desc"
      else "updated_at desc"
      end
      @ideas = Idea.includes(:category, :user).where(conditions).paginate(:page => params[:ideas_page]).order(order)
      render :layout => false
    else
      render :action => :index
    end
  end

  def like
    idea = Idea.find(params[:id])
    vote = Vote.new(:idea => idea,:user => current_user,:like => true)
    vote.save
    idea.update_attribute("points",idea.points+1)
    render :json => idea.to_json(:only => :points) 
  end
  
  def unlike
    idea = Idea.find(params[:id])
    vote = Vote.new(:idea => idea,:user => current_user,:like => false)
    vote.save
    idea.update_attribute("points",idea.points-1)
    render :json => idea.to_json(:only => :points) 
  end

  def favoriate
    @idea = Idea.find(params[:id])
    @idea.favorers << current_user
  end

  def unfavoriate
    @idea = Idea.find(params[:id])
    @idea.favorers.destroy(current_user)
  end

  def preview
    @description = RedCloth.new(params[:description],[:filter_html]).to_html()
    render :layout => false
  end
end
