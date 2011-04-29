require 'test_helper'

class ImpairmentsControllerTest < ActionController::TestCase
  setup do
    @impairment = impairments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:impairments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create impairment" do
    assert_difference('Impairment.count') do
      post :create, :impairment => @impairment.attributes
    end

    assert_redirected_to impairment_path(assigns(:impairment))
  end

  test "should show impairment" do
    get :show, :id => @impairment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @impairment.to_param
    assert_response :success
  end

  test "should update impairment" do
    put :update, :id => @impairment.to_param, :impairment => @impairment.attributes
    assert_redirected_to impairment_path(assigns(:impairment))
  end

  test "should destroy impairment" do
    assert_difference('Impairment.count', -1) do
      delete :destroy, :id => @impairment.to_param
    end

    assert_redirected_to impairments_path
  end
end
