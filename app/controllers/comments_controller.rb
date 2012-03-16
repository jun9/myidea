class CommentsController < ApplicationController
  authorize_resource

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @idea_id = params[:idea_id] 
    @comment.idea = Idea.find(@idea_id)
    @comment.save
  end
end
