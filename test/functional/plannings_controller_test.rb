require 'test_helper'

class PlanningsControllerTest < ActionController::TestCase
  setup do
    @planning = plannings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plannings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planning" do
    assert_difference('Planning.count') do
      post :create, :planning => @planning.attributes
    end

    assert_redirected_to planning_path(assigns(:planning))
  end

  test "should show planning" do
    get :show, :id => @planning.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @planning.to_param
    assert_response :success
  end

  test "should update planning" do
    put :update, :id => @planning.to_param, :planning => @planning.attributes
    assert_redirected_to planning_path(assigns(:planning))
  end

  test "should destroy planning" do
    assert_difference('Planning.count', -1) do
      delete :destroy, :id => @planning.to_param
    end

    assert_redirected_to plannings_path
  end
end
