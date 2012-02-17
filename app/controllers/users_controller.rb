class UsersController < ApplicationController
  authorize_resource

  def index
    if params[:q] && !params[:q].empty?
      @users = User.where("username like ?","%#{params[:q]}%").paginate(:page => params[:page]).order("admin desc")
    else
      @users = User.paginate(:page => params[:page]).order("admin desc")
    end
    render :layout => false
  end

  def show
    @user = User.find(params[:id])
    render :layout => "account"
  end
 
  def authority
    user = User.find(params[:id])
    invalid = false
    if user.admin && (params[:admin] == 'false' || params[:active] == 'false')
      invalid = User.where(:admin => true,:active => true).count == 1 
    end
    user.admin = params[:admin] unless params[:admin].empty?
    user.active = params[:active] unless params[:active].empty?
    if !invalid && user.save(:validate => false)
      head :ok
    else
      render :json => User.find(params[:id]),:status => :unprocessable_entity 
    end  
  end

  def edit 
    @user = User.find(params[:id])
    if session[:login_user].id != @user.id 
      redirect_to root_path, :alert => I18n.t('unauthorized.manage.all')
    end
  end

  def update
    @user = User.find(params[:id])
    if session[:login_user].id != @user.id 
      redirect_to root_path, :alert => I18n.t('unauthorized.manage.all')
    else
      @user.check_password = params[:user][:password].empty? ? false : true
      if @user.update_attributes(params[:user])
        session[:login_user] = LoginUser.new(@user)
        redirect_to root_path, :alert => I18n.t('myidea.notice.user.updated')
      else
        render action:'edit'
      end
    end    
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
      @activities = user.activities.order("created_at desc").limit(30).includes(:idea) 
    end
    render template,:layout => false
  end
end
