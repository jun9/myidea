class UsersController < ApplicationController
  authorize_resource 

  def index
    if params[:q] && !params[:q].empty?
      @users = User.where("username like ?","%#{params[:q]}%").paginate(:page => params[:page]).order("admin")
    else
      @users = User.paginate(:page => params[:page]).order("admin")
    end
    render :layout => false
  end

  def show
    @user = User.find(params[:id])
    render :layout => "account"
  end
 
  def update
    user = User.find(params[:id])
    user.admin = params[:admin] unless params[:admin].empty?
    user.active = params[:active] unless params[:active].empty?
    if user.save(:validate => false)
      head :ok
    else
      render :json => User.find(params[:id]),:status => :unprocessable_entity 
    end  
  end

  def new
    if session[:login_user]
      redirect_to root_path, :alert => I18n.t('errors.user.register') 
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:login_user] = LoginUser.new(@user)
      redirect_to root_path, :alert => I18n.t('notice.user.registed')
    else
      render action:'new'
    end
  end

  def login
    if request.post?
      if user = User.authenticate(params[:account],params[:password])
        if user.active
          session[:login_user] = LoginUser.new(user)
          redirect_to ideas_path
        else
          flash.now[:alert] = I18n.t('errors.user.locked') 
        end
      else
        flash.now[:alert] = I18n.t('errors.user.login') 
      end
    end
  end

  def logout
    session[:login_user] = nil 
    redirect_to ideas_path
  end

  def act
    user = User.find(params[:id])
    if params[:activity]
      template = "ideas" 
      @ideas = case
      when params[:activity] == ACTIVITY_CREATE_IDEA then user.ideas.paginate(:page => params[:page]).order("created_at desc")
      when params[:activity] == ACTIVITY_COMMENT_IDEA then user.commented_ideas.paginate(:page => params[:page]).order("comments.created_at desc").group(:id)    
      when params[:activity] == ACTIVITY_LIKE_IDEA then user.voted_ideas.paginate(:page => params[:page]).order("votes.created_at desc")    
      when params[:activity] == ACTIVITY_FAVORITE_IDEA then user.favored_ideas.paginate(:page => params[:page]).order("favors.created_at desc")    
      end
    else
      template = "act"
      @activities = user.activities.order("created_at desc").limit(30) 
    end
    render template,:layout => false
  end
end
