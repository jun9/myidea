require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @jack = users(:jack)
    @tom = users(:tom)    
  end

  test "authenticate user" do
    assert_not_nil User.authenticate(@jack.username,'123456') 
    assert_not_nil User.authenticate(@jack.email,'123456') 
    assert_nil User.authenticate(@jack.username,'666666') 
    assert_nil User.authenticate(@jack.email,'666666') 
  end

  test "validate empty user" do
    user = User.new
    user.check_password = true
    assert user.invalid?
    assert user.errors[:username].any?
    assert user.errors[:password].any?
    assert user.errors[:email].any?
  end

  test "validate username" do
    user = User.new(:password => '123456',:email => 'mike@qq.com')
    bad = %w{jack ab abcdeabcdeabcde a*^b}
    bad.each do |username|
      user.username = username
      assert user.invalid?,"bad username #{username}"
      assert user.errors[:username].any?
    end
    ok = %w{jim001 abc abcdeabcdeabcd kate}
    ok.each do |username|
      user.username = username
      assert user.valid?,"good username #{username}"
    end
  end

  test "validate password" do
    user = User.new(:username => 'mike',:email => 'mike@qq.com')
    assert user.valid?
    user.check_password = true
    user.password = '123456'
    user.password_confirmation = '123452'
    assert user.invalid?,"confirm password"
    assert user.errors[:password].any?
    bad = %w{12345 1234567890123456789012345678901}
    bad.each do |password|
      user.password = password
      user.password_confirmation = password
      assert user.invalid?,"bad password #{password}"
      assert user.errors[:password].any?
    end
    ok = %w{123456 123456789012345678901234567890}
    ok.each do |password|
      user.password = password
      user.password_confirmation = password
      assert user.valid?,"good password #{password}"
    end
  end

  test "validate email" do
    user = User.new(:username => 'mike',:password => '123456',:password_confirmation => '123456')
    bad = %w{jack@gmail.com dom dom@ dom@123}
    bad.each do |email|
      user.email = email
      assert user.invalid?,"bad email #{email}"
      assert user.errors[:email].any?
    end
    ok = %w{jim001@gmail.com abc@126.com bbcode@qq.com}
    ok.each do |email|
      user.email = email
      assert user.valid?,"good email #{email}"
    end
  end
end
