require 'test_helper'

class TripReasonsControllerTest < ActionController::TestCase
  setup do
    @trip_reason = trip_reasons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trip_reasons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trip_reason" do
    assert_difference('TripReason.count') do
      post :create, :trip_reason => @trip_reason.attributes
    end

    assert_redirected_to trip_reason_path(assigns(:trip_reason))
  end

  test "should show trip_reason" do
    get :show, :id => @trip_reason.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @trip_reason.to_param
    assert_response :success
  end

  test "should update trip_reason" do
    put :update, :id => @trip_reason.to_param, :trip_reason => @trip_reason.attributes
    assert_redirected_to trip_reason_path(assigns(:trip_reason))
  end

  test "should destroy trip_reason" do
    assert_difference('TripReason.count', -1) do
      delete :destroy, :id => @trip_reason.to_param
    end

    assert_redirected_to trip_reasons_path
  end
end
