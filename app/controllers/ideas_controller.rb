# encoding: utf-8
class IdeasController < ApplicationController
  skip_before_filter :authorize,:only => [:index,:tab,:page]
  
  def index
  end
  
  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @idea }
    end
  end

  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
    @idea = Idea.find(params[:id])
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    respond_to do |format|
      if @idea.save
        format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { render action: "new" }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.json
  def update
    @idea = Idea.find(params[:id])

    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :ok }
    end
  end

  def tab
    logger.debug("cate_id = #{params[:cate_id]}")
    logger.debug("style = #{params[:style]}")
    cate_id = session[:cate_id]?session[:cate_id]:params[:cate_id]
    session[:cate_id] = nil  
    if request.xhr?
      if cate_id && !cate_id.empty?
        @category = Category.find(cate_id)
        case params[:style]
        when '0'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:page]).order("updated_at desc")
        when '1'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:page]).order("created_at desc")
        when '2'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:page]).order("points desc")
        when '3'
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:page]).order("updated_at desc")
        else
          @ideas = Idea.where(:category_id => cate_id).paginate(:page => params[:page]).order("updated_at desc")
        end
      else
        case params[:style]
        when '0'
          @ideas = Idea.paginate(:page => params[:page]).order("updated_at desc")
        when '1'
          @ideas = Idea.paginate(:page => params[:page]).order("created_at desc")
        when '2'
          @ideas = Idea.paginate(:page => params[:page]).order("points desc")
        when '3'
          @ideas = Idea.paginate(:page => params[:page]).order("updated_at desc")
        else
          @ideas = Idea.paginate(:page => params[:page]).order("updated_at desc")
        end
      end
      render :layout => false
    else
      session[:cate_id] = params[:cate_id]
      render :action => :index
    end
  end

end
