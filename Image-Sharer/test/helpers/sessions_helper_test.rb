require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = new_user
  end

  test 'remember adds field to cookie' do
    remember(@user)
    assert_equal @user.id, cookies.signed[:user_id]
  end

  test 'forget removes element from cookie' do
    remember(@user)
    forget
    assert_nil cookies.signed[:user_id]
  end

  test 'log_out removes element from cookie' do
    remember(@user)
    log_out
    assert_nil cookies.signed[:user_id]
    assert_nil session[:user_id]
    assert_nil @current_user
  end

  private

  def new_user(name: 'Mohan Chatur CSSastry Savithri', email: 'mohan.chaturvedula@appfolio.com',
               password: 'Test@123', confirm: 'Test@123')
    User.new(name: name, email: email, password: password, password_confirmation: confirm)
  end
end
