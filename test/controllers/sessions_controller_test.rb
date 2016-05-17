require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    dave = users(:one)
    post :create, name: dave.name, password: 'secret'
    assert_redirected_to login_url
    assert_equal dave.id, 980190962
  end

  test "should fail login" do
    dave = users(:one)
    post :create, name: dave.name, password: 'wrong'
    assert_redirected_to login_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
  end

  test "should get destroy" do
    get :destroy
    assert_redirected_to store_url
  end

end
