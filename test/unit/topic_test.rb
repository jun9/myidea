require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic_one = topics(:topic_one)    
    @topic_two = topics(:topic_two)    
  end

  test "validate empty topic" do
    topic = Topic.new
    assert topic.invalid?
    assert topic.errors[:name].any?
  end

  test "validate name" do
    topic = Topic.new()
    max_name = ''
    3.times do
      max_name = max_name + '1234567890'
    end
    topic.name = max_name + '1'
    assert topic.invalid?,"bad name #{topic.name}"
    assert topic.errors[:name].any?
    topic.name = max_name
    assert topic.valid?,"good name #{topic.name}"
  end

  test 'validate remove topic that don`t have ideas' do
    assert !@topic_one.check_product_count
    assert @topic_one.errors[:base].any?
    @topic_two.check_product_count
    assert @topic_two.errors[:base].empty?
  end
end
