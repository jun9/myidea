require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @a_comment = comments(:a_comment)
    @default = ideas(:default)    
    @tom = users(:tom)
  end

  test "everybody not create" do
    post :create,:idea_id => @default.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid comment" do
    assert_difference('Comment.count') do
      post :create,{:idea_id => @default.id,comment: @a_comment.attributes},{:login_user => LoginUser.new(@tom)}
    end
    assert_redirected_to idea_path(@default,:anchor => "last")
  end

  test "login user create invalid comment" do
    @a_comment.content = nil
    post :create,{:idea_id => @default.id,comment: @a_comment.attributes},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to idea_path(@default,:anchor => "comment-form")
    assert_not_nil flash[:alert]
  end

end
