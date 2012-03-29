module CommentsHelper
  def new_comment_button(idea)
    if can? :create,Comment
      content_tag :div,:class=>"btn-group" do
        button_tag I18n.t("app.comment.new"),:class=>"comment-btn btn btn-info","data-idea"=> idea.id
      end
    end
  end
end
