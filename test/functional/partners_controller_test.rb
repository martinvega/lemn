require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  setup do
    @partner = Fabricate(:partner)
    @user = @partner.user
  end

  test "should get index" do
    sign_in @user

    get :index
    assert_response :success
    assert_not_nil assigns(:partners)
    assert_not_nil assigns(:partners)
    assert_select '#unexpected_error', false
    assert_template 'partners/index'
  end

  test "should get new" do
    sign_in @user

    get :new
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_select '#unexpected_error', false
    assert_template 'partners/new'
  end

  test "should create partner" do
    sign_in @user

    assert_difference('Partner.count') do
      post :create, :user_id => @user.id, :partner => Fabricate.attributes_for(:partner).slice(
        *Partner.accessible_attributes
      )
    end

    assert_redirected_to partner_path(assigns(:partner))
  end

  test "should show partner" do
    sign_in @user

    get :show, :id => @partner
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_select '#unexpected_error', false
    assert_template 'partners/show'
  end

  test "should get edit" do
    sign_in @user

    get :edit, :id => @partner
    assert_response :success
    assert_not_nil assigns(:partner)
    assert_select '#unexpected_error', false
    assert_template 'partners/edit'
  end

  test "should update partner" do
    sign_in @user

    assert_no_difference 'Partner.count' do
      put :update, :user_id => @user.id, :id => @partner, :partner => Fabricate.attributes_for(
        :partner, :name => 'updated_name'
      ).slice(
        *Partner.accessible_attributes
      )
    end

    assert_redirected_to partner_path(assigns(:partner))
    assert_equal 'updated_name', @partner.reload.name
  end

  test "should destroy partner" do
    sign_in @user

    assert_difference('Partner.count', -1) do
      delete :destroy, :id => @partner
    end

    assert_redirected_to partners_path
  end
end
