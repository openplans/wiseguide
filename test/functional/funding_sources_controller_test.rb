require 'test_helper'

class FundingSourcesControllerTest < ActionController::TestCase
  setup do
    @funding_source = funding_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:funding_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create funding_source" do
    assert_difference('FundingSource.count') do
      post :create, :funding_source => @funding_source.attributes
    end

    assert_redirected_to funding_source_path(assigns(:funding_source))
  end

  test "should show funding_source" do
    get :show, :id => @funding_source.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @funding_source.to_param
    assert_response :success
  end

  test "should update funding_source" do
    put :update, :id => @funding_source.to_param, :funding_source => @funding_source.attributes
    assert_redirected_to funding_source_path(assigns(:funding_source))
  end

  test "should destroy funding_source" do
    assert_difference('FundingSource.count', -1) do
      delete :destroy, :id => @funding_source.to_param
    end

    assert_redirected_to funding_sources_path
  end
end
