require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  def setup
    @partner = Fabricate(:partner)
    @user = @partner.user
  end

  test 'create' do
    assert_difference 'Partner.count' do
      @partner = Fabricate.build(:partner)
      @partner.user = @user

      assert @partner.save
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Partner.count' do
        assert @partner.update_attributes( :name => 'Updated name')
      end
    end

    assert_equal 'Updated name', @partner.reload.name
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Partner.count', -1) { @partner.destroy }
    end
  end

  test 'validates blank attributes' do
    @partner.name = ''
    @partner.lastname = ''
    @partner.user_id = nil

    assert @partner.invalid?
    assert_equal 3, @partner.errors.size
    assert_equal [error_message_from_model(@partner, :name, :blank)],
      @partner.errors[:name]
    assert_equal [error_message_from_model(@partner, :lastname, :blank)],
      @partner.errors[:lastname]
    assert_equal [error_message_from_model(@partner, :user_id, :blank)],
      @partner.errors[:user_id]
  end

  test 'validates attributes are well formated' do
    @partner.email = 'lemn.com.ar'
    @partner.document = '1abc1'
    @partner.phone = '1555638abc'
    @partner.mobile_phone = '48329abc'

    assert @partner.invalid?
    assert_equal 4, @partner.errors.count
    assert_equal [error_message_from_model(@partner, :document, :not_a_number)],
      @partner.errors[:document]
    assert_equal [error_message_from_model(@partner, :phone, :not_a_number)],
      @partner.errors[:phone]
    assert_equal [error_message_from_model(@partner, :mobile_phone, :not_a_number)],
      @partner.errors[:mobile_phone]
    assert_equal [error_message_from_model(@partner, :email, :invalid)],
      @partner.errors[:email]
  end

  test 'validates length of long attributes' do
    @partner.name = 'abcde' * 52
    @partner.lastname = 'abcde' * 52
    @partner.address = 'abcde' * 52
    @partner.email = "#{@partner.name}@lemn.com.ar"

    assert @partner.invalid?

    assert_equal 4, @partner.errors.count
    assert_equal [
      error_message_from_model(@partner, :name, :too_long, :count => 255)
    ], @partner.errors[:name]
    assert_equal [
      error_message_from_model(@partner, :lastname, :too_long, :count => 255)
    ], @partner.errors[:lastname]
    assert_equal [
      error_message_from_model(@partner, :address, :too_long, :count => 255)
    ], @partner.errors[:address]
    assert_equal [
      error_message_from_model(@partner, :email, :too_long, :count => 255)
    ], @partner.errors[:email]
  end

  test 'validates dates attributes' do
    @partner.birth_date = Date.today.years_ago 3
    @partner.admission_date = Date.tomorrow

    assert @partner.invalid?
    assert_equal 2, @partner.errors.size
    assert_equal [
      I18n.t('errors.messages.on_or_before', :restriction => I18n.l(Date.today.years_ago 4))
    ], @partner.errors[:birth_date]
    assert_equal [
      I18n.t('errors.messages.on_or_before', :restriction => I18n.l(Date.today))
    ], @partner.errors[:admission_date]
  end

  test 'validates unique attributes' do
    new_partner = Fabricate(:partner)
    @partner.email = new_partner.email
    @partner.document = new_partner.document
    @partner.name = new_partner.name
    @partner.lastname = new_partner.lastname

    assert @partner.invalid?
    assert_equal 3, @partner.errors.size
    assert_equal [error_message_from_model(@partner, :email, :taken)],
      @partner.errors[:email]
    assert_equal [error_message_from_model(@partner, :document, :taken)],
      @partner.errors[:document]
    assert_equal [error_message_from_model(@partner, :name, :taken)],
      @partner.errors[:name]
  end
end

