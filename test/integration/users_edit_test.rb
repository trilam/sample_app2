require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    @user = users(:Tri)
  end

  test "unsuccessful edit" do
    login_as(@user, password: 'abc123')
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    login_as(@user, password: 'abc123')
    assert_redirected_to edit_user_path(@user)
    # test this later assert_template 'users/edit'
    patch user_path(@user), user: { name: "Foo Bar", email: "foo@bar.com", password: "", password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Foo Bar"
    assert_equal @user.email, "foo@bar.com"
  end
   

end
