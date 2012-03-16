require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @under_review = ideas(:under_review)
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "everybody get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ideas) 
  end
=begin
  test "everybody get search" do
    get :search,:q => "test"
    assert_template "search"
  end

  test "everybody ajax search" do
    xhr :get,:search,:q => "test"
    assert_template :partial => "_search_tab"
  end

  test "everybody not get promotion" do
    get :promotion
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user get promotion" do
    get :promotion,nil,{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end
=end
  test "everybody not create" do
    xhr :post,:create
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create" do
    sign_in @tom
    assert_difference('Idea.count') do
      xhr :post,:create,{idea: @under_review.attributes}
    end
    assert_response :success
  end

  test "login user create fail" do
    sign_in @tom
    @under_review.title = nil
    xhr :post,:create,{idea: @under_review.attributes}
    assert assigns(:idea).errors.any?
  end
=begin
  test "everybody show idea" do
    get :show, id: @default.to_param
    assert_response :success
    assert_not_nil assigns(:idea)
    assert_not_nil assigns(:comment)
  end

  test "everybody ajax show idea" do
    xhr :get,:show, id: @default.to_param
    assert_template :partial => "_comments" 
  end

  test "normal user not get edit" do
    get :edit,{ id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin not get edit" do
    get :edit,{ id: @default.to_param},{:login_user => LoginUser.new(@jack)}
    assert_response :success
  end

  test "normal user not update idea" do
    put :update,{ id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin update valid idea" do
    put :update,{id: @default.to_param, :cate => { :id => @default.category.id }},{:login_user => LoginUser.new(@jack)}
    assert_redirected_to idea_path(assigns(:idea))
  end

  test "admin update invalid idea" do
    put :update,{id: @default.to_param, :cate => { :id => nil }},{:login_user => LoginUser.new(@jack)}
    assert assigns(:idea).errors.any?
    assert_template 'edit'
  end

  test "normal user not handle idea" do
    post :handle,{ id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin go to handle idea page" do
    get :handle,{id: @default.to_param, :cate => { :id => @default.category.id }},{:login_user => LoginUser.new(@jack)}
    assert_template 'handle'
  end

  test "admin handle idea" do
    post :handle,{id: @default.to_param, :cate => { :id => @default.category.id }},{:login_user => LoginUser.new(@jack)}
    assert_redirected_to idea_path(assigns(:idea))
  end

  test "everybody get tab" do
    get :tab,{ cate_id: @environment.id,status:IDEA_SORT_HOT}
    assert_template 'index' 
  end

  test "everybody ajax get tab" do
    xhr :get,:tab,{ cate_id: @environment.id,status:IDEA_SORT_HOT}
    assert_template 'tab' 
  end

  test "everybody not like idea" do
    xhr :post, :like,id: @default.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user like idea" do
    xhr :post, :like,{id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    idea = JSON.parse(@response.body)
    assert_equal @default.points+1,idea['points']
  end

  test "everybody not unlike idea" do
    xhr :post, :unlike,id: @default.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user unlike idea" do
    xhr :post, :unlike,{id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    idea = JSON.parse(@response.body)
    assert_equal @default.points-1,idea['points']
  end

  test "everybody not favoriate idea" do
    xhr :post,:favoriate,id: @default.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody not unfavoriate idea" do
    xhr :post,:unfavoriate,id: @default.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody not preview idea" do
    xhr :post, :preview,id: @default.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user favoriate idea" do
    xhr :post, :favoriate,{id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end

  test "login user unfavoriate idea" do
    xhr :post, :unfavoriate,{id: @default.to_param},{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end

  test "login user preview idea" do
    xhr :post, :preview,{description: @default.description},{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end
=end
end
