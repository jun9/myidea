class CommentsController < ApplicationController
  authorize_resource

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.idea = Idea.find(params[:idea_id])
    @comment.save
  end
end
