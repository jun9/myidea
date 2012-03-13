class TopicsController < ApplicationController
  authorize_resource
  layout false

  def index
    @topics = Topic.order("created_at desc")
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.save
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
  end

end
