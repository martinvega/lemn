require 'test_helper'

class AssistanceTest < ActiveSupport::TestCase
  def setup
    @assistance = Fabricate(:assistance)
    @user = @assistance.user
  end

  test 'create' do
    assert_difference 'Assistance.count' do
      @assistance = Fabricate.build(:assistance)
      @assistance.user = @user

      assert @assistance.save
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Partner.count' do
        assert @assistance.update_attributes( :date => 2.days.ago.to_date)
      end
    end

    assert_equal 2.days.ago.to_date, @assistance.date
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Assistance.count', -1) { @assistance.destroy }
    end
  end

  test 'validates blank attributes' do
    @assistance.date = ''
    @assistance.partner_id = nil
    @assistance.user_id = nil

    assert @assistance.invalid?
    assert_equal 3, @assistance.errors.size
    assert_equal [error_message_from_model(@assistance, :date, :blank)],
      @assistance.errors[:date]
    assert_equal [error_message_from_model(@assistance, :partner_id, :blank)],
      @assistance.errors[:partner_id]
    assert_equal [error_message_from_model(@assistance, :user_id, :blank)],
      @assistance.errors[:user_id]
  end

  test 'validates date attribute' do
    @assistance.date = Date.tomorrow

    assert @assistance.invalid?
    assert_equal 1, @assistance.errors.size
    assert_equal [
      I18n.t('errors.messages.on_or_before', :restriction => I18n.l(Date.today))
    ], @assistance.errors[:date]
  end

  test 'validates unique attributes' do
    new_assistance = Fabricate(:assistance)
    @assistance.date = new_assistance.date
    @assistance.partner = new_assistance.partner

    assert @assistance.invalid?
    assert_equal 1, @assistance.errors.size
    assert_equal [error_message_from_model(@assistance, :date, :taken)],
      @assistance.errors[:date]
  end
end


