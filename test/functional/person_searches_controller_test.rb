require 'test_helper'

class PersonSearchesControllerTest < ActionController::TestCase
  setup do
    @person_search = person_searches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_search" do
    assert_difference('PersonSearch.count') do
      post :create, person_search: { programming_language: @person_search.programming_language, zipcode: @person_search.zipcode }
    end

    assert_redirected_to person_search_path(assigns(:person_search))
  end

  test "should show person_search" do
    get :show, id: @person_search
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person_search
    assert_response :success
  end

  test "should update person_search" do
    put :update, id: @person_search, person_search: { programming_language: @person_search.programming_language, zipcode: @person_search.zipcode }
    assert_redirected_to person_search_path(assigns(:person_search))
  end

  test "should destroy person_search" do
    assert_difference('PersonSearch.count', -1) do
      delete :destroy, id: @person_search
    end

    assert_redirected_to person_searches_path
  end
end
