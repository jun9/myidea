require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
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
    assert_not_nil assigns(:users)
  end

  test "normal user not authority" do
    sign_in @tom
    xhr :put,:authority,{id: @tom.to_param,admin:"true"}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin authority" do
    sign_in @jack
    xhr :put,:authority,{id: @tom.to_param,admin:"true"}
    assert_response :success
    assert assigns(:user).errors[:base].empty?
  end

=begin
  test "everybody show user" do
    get :show, id: @tom.to_param
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "everybody get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "login user edit himself" do
    get :edit,{id: @tom.to_param},{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end

  test "login user edit other" do
    get :edit,{id: @jack.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody edit user" do
    get :edit, id: @tom.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end
  
  test "login user update himself" do
    put :update,{id: @tom.to_param,:user => {:username => "danjiang",:email => "danjiang5956@gmail.com",:password=>"123456",:password_confirmation => "123456"}},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('notice.user.updated'),flash[:alert]
  end

  test "login user update himself invalid" do
    put :update,{id: @tom.to_param,:user => {:username => "danjiang",:email => "danjiang5956@gmail.com",:password=>"123456",:password_confirmation => "1234567"}},{:login_user => LoginUser.new(@tom)}
    assert_template "edit"
    assert assigns(:user).invalid?
  end

  test "login user update other" do
    put :update,{id: @jack.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody update user" do
    get :update, id: @tom.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "user goto login page" do
    get :login
    assert_response :success
    assert_template "login"
  end
    
  test "user login success" do
    post :login,{:account => @jack.username,:password => '123456' }
    assert_redirected_to ideas_path
    assert_not_nil session["login_user"]
  end
 
  test "everybody act with activity" do
    get :act,{id:@tom.to_param,:activity => ACTIVITY_CREATE_IDEA}
    assert_template 'ideas'
    assert_not_nil assigns(:ideas)
  end

  test "everybody act without activity" do
    get :act,id:@tom.to_param
    assert_template 'act'
    assert_not_nil assigns(:activities)
  end
=end
end
