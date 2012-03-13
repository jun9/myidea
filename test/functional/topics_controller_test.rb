require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @topic_one = topics(:topic_one)
    @topic_two = topics(:topic_two)
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "normal user not get index" do
    sign_in @tom
    get :index
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get index" do
    sign_in @jack
    get :index
    assert_response :success
    assert_not_nil assigns(:topics)
    assert_not_nil assigns(:topic)
  end

  test "normal user not create" do
    sign_in @tom
    xhr :post,:create
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin create" do
    sign_in @jack
    assert_difference('Topic.count') do
      xhr :post,:create,:topic => { :name => 'a new topic'}
    end
    assert_response :success
  end

  test "normal user not destroy" do
    sign_in @tom
    xhr :delete,:destroy,{:id => @topic_two.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin destroy valid topic" do
    sign_in @jack
    assert_difference('Topic.count',-1) do
      xhr :delete,:destroy,{:id => @topic_two.id}
    end 
    assert_response :success
  end

  test "admin destroy invalid topic" do
    sign_in @jack
    assert_no_difference('Topic.count') do
      xhr :delete,:destroy,{:id => @topic_one.id}
    end 
    assert_response :success
  end

  test "normal user not update" do
    sign_in @tom
    xhr :put,:update,{:id => @topic_one.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin update" do
    sign_in @jack
    assert_no_difference('Topic.count') do
      xhr :put,:update,{:id => @topic_one.id,:topic => {:name => "update a name"}}
    end
    assert_response :success
  end

end
