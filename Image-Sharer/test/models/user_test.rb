require 'test_helper'
require 'create_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = new_user
  end

  def test_user_validates_presence_of_name_and_email_and_password
    assert_predicate @user, :valid?
  end

  def test_user_validates_presence_of_name
    error = { name: ["Name can't be blank"] }
    names = [nil, '']
    names.each do |name|
      @user.name = name
      refute_predicate @user, :valid?
      assert_equal error, @user.errors.messages
    end
  end

  def test_user_validates_length_of_name
    error = { name: ['Name is too long'] }
    @user.name = 'm' * 31
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages

    @user.name = 'm' * 30
    error = {}
    assert_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_user_validates_presence_of_email
    error = { email: ["Email can't be blank", 'Email is invalid'] }
    values = [nil, '']
    values.each do |value|
      @user.email = value
      refute_predicate @user, :valid?
      assert_equal error, @user.errors.messages
    end
  end

  def test_user_validates_uniqueness_of_email
    error = { email: ['User already exists'] }
    @user.save
    user_dup = @user.dup
    refute_predicate user_dup, :valid?
    assert_equal error, user_dup.errors.messages

    user_dup.email.upcase!
    refute_predicate user_dup, :valid?
    assert_equal error, user_dup.errors.messages
  end

  def test_user_validates_case_of_email
    emails = %w(MOHAN.Chaturvedula@appfolio.com MOHAN.CHATURVEDULA@APPFOLIO.COM)
    emails.each do |email|
      @user.email = email
      @user.save
      assert_equal email.downcase, @user.reload.email
    end
  end

  def test_user_validates_format_of_email
    error = { email: ['Email is invalid'] }
    emails = %w(first.last first.last@example)
    emails.each do |email|
      @user.email = email
      refute_predicate @user, :valid?
      assert_equal error, @user.errors.messages
    end
  end

  def test_user_validates_length_of_email
    error = { email: ['Email is too long'] }
    @user.email = 'contact-admin-hello-webmaster-appfolio@please-try-to.send-me-an-email-if-you-can-possibly-'\
                  'begin-to-remember-this-coz.this-is-the-longest-email-address-known-to-man-but-to-be-honest.'\
                  'this-is-such-a-stupidly-long-sub-domain-it-could-go-on-forever.pacraig.com' # 255
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages

    @user.email = 'contact-admin-hello-webmaster-appfolio@please-try-to.send-me-an-email-if-you-can-possibly-'\
                  'begin-to-remember-this-coz.this-is-the-longest-email-address-known-to-man-but-to-be-honest'\
                  '.this-is-such-a-stupidly-long-sub-domain-it-could-go-on-forever.pacraig.co' # 254
    error = {}
    assert_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_user_validates_presence_of_password
    error = { password: ["can't be blank"] }
    passwords = [nil, '']
    passwords.each do |password|
      @user.password = password
      refute_predicate @user, :valid?
      assert_equal error, @user.errors.messages
    end
  end

  def test_user_validates_presence_of_non_blank_password
    error = { password: ["can't be blank"] }
    @user.password = ' ' * 5
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_user_validates_length_of_password
    error = { password: ['Password is too short'] }
    @user.password = 'm' * 4
    @user.password_confirmation = @user.password
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages

    @user.password = 'm' * 5
    @user.password_confirmation = @user.password
    error = {}
    assert_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_user_validates_presence_of_confirm_password
    error = { password_confirmation: ["Confirm Password can't be blank"] }
    @user.password_confirmation = nil
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_user_validates_match_of_password_and_confirm_password
    error = { password_confirmation: ["doesn't match Password"] }
    @user.password_confirmation = @user.password * 2
    refute_predicate @user, :valid?
    assert_equal error, @user.errors.messages
  end

  def test_validates_user_and_image_association
    assert_equal 0, @user.images.size
    CreateHelper.create_image(user: @user)
    assert_equal 1, @user.images.size
  end

  private

  def new_user(name: 'Mohan Chatur CSSastry Savithri', email: 'mohan.chaturvedula@appfolio.com',
               password: 'Test@123', confirm: 'Test@123')
    User.new(name: name, email: email, password: password, password_confirmation: confirm)
  end
end
