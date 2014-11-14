require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:Tri)
    @other_user=users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit to login url when not logged in" do
    get :edit, id: @user.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update to login url when not logged in" do
    patch :update, id: @user.id, user: { name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    login_as(@other_user)
    get :edit, id:@user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    login_as(@other_user)
    patch :update, id:@user, user: { name:@user, email:@user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index to login url if not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy url to login url wher not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id:@user
    end
    assert_redirected_to login_url

  end

  test "should redirect destroy url to root url when logged in as non-admin" do
    login_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id:@user
    end
    assert_redirected_to root_url
  end
   

end
