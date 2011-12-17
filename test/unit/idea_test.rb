require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  def setup
    @default = ideas(:default)
    @under_review = ideas(:under_review)
    @reviewed = ideas(:reviewed)
    @in_the_works = ideas(:in_the_works)
    @launched = ideas(:launched)
  end    

   test "change status" do
     @default.change_status
     assert_equal IDEA_STATUS_UNDER_REVIEW,@default.status 
     @under_review.change_status
     assert_equal IDEA_STATUS_REVIEWED,@under_review.status 
     @reviewed.change_status
     assert_equal IDEA_STATUS_IN_THE_WORKS,@reviewed.status 
     @in_the_works.change_status
     assert_equal IDEA_STATUS_LAUNCHED,@in_the_works.status 
     assert !@launched.change_status
     assert @launched.errors[:status].any?
   end
  
  test "validate empty idea" do
    idea = Idea.new
    assert idea.invalid?
    assert idea.errors[:title].any?
    assert idea.errors[:description].any?
    assert idea.errors[:category_id].any?
  end

  test "validate idea title maxlength" do
    title = ""
    12.times do
      title = @default.title + title
    end
    @default.title = title
    assert @default.valid?
    assert @default.errors[:title].empty?
    @default.title = @default.title + "a"
    assert @default.invalid?
    assert @default.errors[:title].any?
  end

  test "validate idea description maxlength" do
    description = ""
    20.times do
      description = @default.description + description
    end
    @default.description = description
    assert @default.valid?
    assert @default.errors[:description].empty?
    @default.description = @default.description + "a"
    assert @default.invalid?
    assert @default.errors[:description].any?
  end

end
