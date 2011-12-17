require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    @jack = users(:jack)
    @tom = users(:tom)
    @environment = categories(:environment)
    @nothing = categories(:nothing) 
  end

  test "normal user not get index" do
    get :index,nil,{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get index" do
    get :index,nil,{:login_user => LoginUser.new(@jack)}
    assert_response :success
    assert_not_nil assigns(:categories)
  end
  
  test "normal user not create category" do
    xhr :post,:create,nil,{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end
 
  test "admin create category" do
    assert_difference('Category.count') do
      xhr :post,:create, {:name => @environment.name},{:login_user => LoginUser.new(@jack)}
    end
    assert_response :success
  end

  test "normal user not destroy category" do
    xhr :delete,:destroy,{:id => @nothing.id },{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin destroy valid category" do
    xhr :delete,:destroy,{:id => @nothing.id },{:login_user => LoginUser.new(@jack)}
    assert_response :success
  end

  test "admin destroy invalid category" do
    xhr :delete,:destroy,{:id => @environment.id },{:login_user => LoginUser.new(@jack)}
    assert_response :unprocessable_entity
    errors = JSON.parse(@response.body)
    assert_equal I18n.t('myidea.errors.category.zero_products'),errors['base'][0]
  end

  test "normal user not update category" do
    xhr :put,:update,{:id => @environment.to_param},{:login_user => LoginUser.new(@tom)}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin update category" do
    xhr :put,:update,{:id => @environment.id,:name => @environment.name},{:login_user => LoginUser.new(@jack)}
    assert_response :success
    assert_not_nil assigns(:category)
  end

end
