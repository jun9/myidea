# encoding: utf-8
class CommentsController < ApplicationController
  def create
    comment = Comment.new(params[:comment])
    comment.user = current_user
    comment.idea = Idea.find(params[:idea_id])
    if comment.save
      session[:comments_page] = Comment.last_page_number(:idea_id => comment.idea.id) 
      redirect_to idea_path(comment.idea,:anchor => "comments-top")
    else
      redirect_to idea_path(comment.idea,:anchor => "comment-form"),:alert => "发布评论失败，评论内容不能为空"
    end
  end
end
