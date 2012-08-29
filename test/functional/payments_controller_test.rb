require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @payment = Fabricate(:payment)
    @user = @payment.user
  end

  test "should get index" do
    sign_in @user

    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
    assert_select '#unexpected_error', false
    assert_template 'payments/index'

  end

  test "should get new" do
    sign_in @user

    get :new
    assert_response :success
    assert_not_nil assigns(:payment)
    assert_select '#unexpected_error', false
    assert_template 'payments/new'
  end

  test "should create payment" do
    sign_in @user

    assert_difference('Payment.count') do
      post :create, :user_id => @user.id, :payment => Fabricate.attributes_for(:payment).slice(
        *Payment.accessible_attributes
      )
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  test "should show payment" do
    sign_in @user

    get :show, :id => @payment
    assert_response :success
    assert_not_nil assigns(:payment)
    assert_select '#unexpected_error', false
    assert_template 'payments/show'
  end

  test "should get edit" do
    sign_in @user

    assert_no_difference 'Payment.count' do
      get :edit, :id => @payment
    end

    assert_response :success
    assert_not_nil assigns(:payment)
    assert_select '#unexpected_error', false
    assert_template 'payments/edit'
  end

  test "should update payment" do
    sign_in @user

    assert_no_difference 'Payment.count' do
      put :update, :user_id => @user.id, :id => @payment, :payment => Fabricate.attributes_for(
        :payment, :concept => 'updated_concept').slice(
          *Payment.accessible_attributes
        )
    end

    assert_redirected_to payment_path(assigns(:payment))
    assert_equal 'updated_concept', @payment.reload.concept
  end

  test "should destroy payment" do
    sign_in @user

    assert_difference('Payment.count', -1) do
      delete :destroy, :id => @payment
    end

    assert_redirected_to payments_path
  end

  test "should get last expired payments" do
    sign_in @user

    expired_1 = Fabricate(:payment, :date => Date.today.prev_month)
    expired_2 = Fabricate(:payment, :date => Date.today.prev_month, :user_id => expired_1.user.id)

    get :index, expired => true
    assert_response :sucess
    assert_equal assigns(:payments), 1

  end

  test "should get next to expire payments" do

  end
end
