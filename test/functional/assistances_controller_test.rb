require 'test_helper'

class AssistancesControllerTest < ActionController::TestCase
  setup do
    @assistance = Fabricate(:assistance)
    @user = @assistance.user
  end

  test "should get index" do
    sign_in @user

    get :index
    assert_response :success
    assert_not_nil assigns(:assistances)
    assert_select '#unexpected_error', false
    assert_template 'assistances/index'
  end

  test "should get new" do
    sign_in @user

    get :new
    assert_response :success
    assert_not_nil assigns(:assistance)
    assert_select '#unexpected_error', false
    assert_template 'assistances/new'
  end

  test "should create assistance" do
    sign_in @user

    assert_difference('Assistance.count') do
      post :create, :user_id => @user.id, :assistance => Fabricate.attributes_for(:assistance).slice(
        *Assistance.accessible_attributes
      )
    end

    assert_redirected_to assistance_path(assigns(:assistance))
  end

  test "should show assistance" do
    sign_in @user

    get :show, :id => @assistance
    assert_response :success
    assert_not_nil assigns(:assistance)
    assert_select '#unexpected_error', false
    assert_template 'assistances/show'
  end

  test "should get edit" do
    sign_in @user
    assert_no_difference 'Assistance.count' do
      get :edit, :id => @assistance
    end

    assert_response :success
    assert_not_nil assigns(:assistance)
    assert_select '#unexpected_error', false
    assert_template 'assistances/edit'
  end

  test "should update assistance" do
    sign_in @user

    assert_no_difference 'Assistance.count' do
      put :update, :user_id => @user.id, :id => @assistance, :assistance => Fabricate.attributes_for(
        :assistance, :date => Date.yesterday).slice(
          *Assistance.accessible_attributes
        )
    end

    assert_redirected_to assistance_path(assigns(:assistance))
    assert_equal Date.yesterday, @assistance.reload.date
  end

  test "should destroy assistance" do
    sign_in @user

    assert_difference('Assistance.count', -1) do
      delete :destroy, :id => @assistance
    end

    assert_redirected_to assistances_path
  end
end
