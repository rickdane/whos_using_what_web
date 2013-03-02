require 'test_helper'

class AnewtablesControllerTest < ActionController::TestCase
  setup do
    @anewtable = anewtables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:anewtables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create anewtable" do
    assert_difference('Anewtable.count') do
      post :create, anewtable: { tablevalue: @anewtable.tablevalue }
    end

    assert_redirected_to anewtable_path(assigns(:anewtable))
  end

  test "should show anewtable" do
    get :show, id: @anewtable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @anewtable
    assert_response :success
  end

  test "should update anewtable" do
    put :update, id: @anewtable, anewtable: { tablevalue: @anewtable.tablevalue }
    assert_redirected_to anewtable_path(assigns(:anewtable))
  end

  test "should destroy anewtable" do
    assert_difference('Anewtable.count', -1) do
      delete :destroy, id: @anewtable
    end

    assert_redirected_to anewtables_path
  end
end
