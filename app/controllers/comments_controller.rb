class CommentsController < ApplicationController
  authorize_resource

  def create
    comment = Comment.new(params[:comment])
    comment.user = current_user
    comment.idea = Idea.find(params[:idea_id])
    if comment.save
      session[:comments_page] = Comment.last_page_number(:idea_id => comment.idea.id) 
      redirect_to idea_path(comment.idea,:anchor => "last")
    else
      redirect_to idea_path(comment.idea,:anchor => "comment-form"),:alert => comment.errors.full_messages.join(",")
    end
  end
end
