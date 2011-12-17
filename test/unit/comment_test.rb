require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @a_comment = comments(:a_comment)    
  end

  test "validate empty comment" do
    comment = Comment.new
    assert comment.invalid?
    assert comment.errors[:content].any?
  end

  test "validate comment content maxlength" do
    content = ""
    10.times do
      content = @a_comment.content + content
    end
    @a_comment.content = content
    assert @a_comment.valid?
    assert @a_comment.errors[:content].empty?
    @a_comment.content = @a_comment.content + "a"
    assert @a_comment.invalid?
    assert @a_comment.errors[:content].any?
  end

end
