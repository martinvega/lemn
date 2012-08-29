require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  def setup
    @payment = Fabricate(:payment)
    @user = @payment.user
  end

  test 'create' do
    assert_difference 'Payment.count' do
      @payment = Fabricate.build(:payment)
      @payment.user = @user

      assert @payment.save
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Payment.count' do
        assert @payment.update_attributes( :concept => 'Updated concept')
      end
    end

    assert_equal 'Updated concept', @payment.reload.concept
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Payment.count', -1) { @payment.destroy }
    end
  end

  test 'validates blank attributes' do
    @payment.date = ''
    @payment.amount = ''
    @payment.concept = ''
    @payment.partner_id = nil
    @payment.user_id = nil

    assert @payment.invalid?
    assert_equal 5, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :date, :blank)],
      @payment.errors[:date]
    assert_equal [error_message_from_model(@payment, :concept, :blank)],
      @payment.errors[:concept]
    assert_equal [error_message_from_model(@payment, :amount, :blank)],
      @payment.errors[:amount]
    assert_equal [error_message_from_model(@payment, :user_id, :blank)],
      @payment.errors[:user_id]
    assert_equal [error_message_from_model(@payment, :partner_id, :blank)],
      @payment.errors[:partner_id]
  end

  test 'validates length of long attributes' do
    @payment.concept = 'abcde' * 52

    assert @payment.invalid?

    assert_equal 1, @payment.errors.count
    assert_equal [
      error_message_from_model(@payment, :concept, :too_long, :count => 255)
    ], @payment.errors[:concept]
  end

  test 'validates dates attributes' do
    @payment.date = 8.days.from_now.to_date

    assert @payment.invalid?
    assert_equal 1, @payment.errors.size
    assert_equal [
      I18n.t('errors.messages.on_or_before', :restriction => I18n.l(7.days.from_now.to_date))
    ], @payment.errors[:date]
  end

  test 'validates unique attributes' do
    new_payment = Fabricate(:payment)
    @payment.date = new_payment.date
    @payment.partner = new_payment.partner

    assert @payment.invalid?
    assert_equal 1, @payment.errors.size
    assert_equal [error_message_from_model(@payment, :date, :taken)],
      @payment.errors[:date]
  end
end


