require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @environment = categories(:environment) 
    @nothing = categories(:nothing) 
  end

  test "check product count" do
     assert !@environment.check_product_count 
     assert @environment.errors[:base].any?

     @nothing.check_product_count
     assert @nothing.errors[:base].empty?
  end
 
  test "validate empty category" do
    category = Category.new
    assert category.invalid?
    assert category.errors[:name].any?
  end 
end
