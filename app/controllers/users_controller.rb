class UsersController < ApplicationController
  authorize_resource

  def index
    if params[:q] && !params[:q].empty?
      @users = User.where("username like ? OR email like ?","%#{params[:q]}%","%#{params[:q]}%").paginate(:page => params[:page]).order("admin desc")
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
    @user = User.find(params[:id])
    @user.admin = params[:admin]
    @user.save(:validate => false)
  end

  def edit 
    @user = User.find(params[:id])
    if current_user.id != @user.id 
      redirect_to root_path, :alert => I18n.t('unauthorized.manage.all')
    elsif request.xhr?
      render :layout => false
    else
      render :layout => "profile"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => I18n.t('myidea.notice.user.edit')
    else
      render action:'edit',:layout => "profile"
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
