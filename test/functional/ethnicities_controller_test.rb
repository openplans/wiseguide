require 'test_helper'

class EthnicitiesControllerTest < ActionController::TestCase
  setup do
    @ethnicity = ethnicities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ethnicities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ethnicity" do
    assert_difference('Ethnicity.count') do
      post :create, :ethnicity => @ethnicity.attributes
    end

    assert_redirected_to ethnicity_path(assigns(:ethnicity))
  end

  test "should show ethnicity" do
    get :show, :id => @ethnicity.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ethnicity.to_param
    assert_response :success
  end

  test "should update ethnicity" do
    put :update, :id => @ethnicity.to_param, :ethnicity => @ethnicity.attributes
    assert_redirected_to ethnicity_path(assigns(:ethnicity))
  end

  test "should destroy ethnicity" do
    assert_difference('Ethnicity.count', -1) do
      delete :destroy, :id => @ethnicity.to_param
    end

    assert_redirected_to ethnicities_path
  end
end
