require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'Mohan', email: 'mohan.chaturvedula@appfolio.com',
                         password: 'Test@123', password_confirmation: 'Test@123')
  end

  test 'should get new' do
    get new_session_url
    assert_response :ok
    assert_select ".test-login-form[action='#{sessions_path}']"
    assert_select 'label[for=session_email]', text: '* Email'
    assert_select '.test-login-email'
    assert_select 'label[for=session_password]', text: '* Password'
    assert_select '.test-login-password'
    assert_select '.test-login-submit[value=\'Log In\']'
    assert_select '.test-login-remember_me'
  end

  test 'create should redirect to root when we enter valid credentials' do
    post sessions_url, params: {
      session: { email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123' }
    }
    assert_equal @user.id, session[:user_id]
    assert_equal "Welcome back, #{@user.name}", flash[:success]
    assert_redirected_to root_url
  end

  test 'create should render to login when we enter invalid credentials' do
    post sessions_url, params: {
      session: { email: 'mohan.chaturvedula@appfolio.com', password: 'Test@12' }
    }
    assert_response :unprocessable_entity
    assert_equal 'Invalid user/password combination', flash.now[:danger]
  end

  test 'root should contain login and register links when no login has occurred' do
    get root_url
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select '.test-user-register'
    assert_select '.test-user-login'
    assert_select '.test-logged-user', false
  end

  test 'root should contain logout when login has occurred' do
    post sessions_url, params: {
      session: { email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123' }
    }
    get root_url
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select '.test-user-register', false
    assert_select '.test-user-login', false
    assert_select '.test-logged-user'
  end

  test 'logged out user should see root' do
    post sessions_url, params: {
      session: { email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123' }
    }
    delete session_url(User.last.id)
    assert_redirected_to root_url
    assert_equal 'You have successfully logged out', flash[:success]
    assert_nil session[:user_id]
    assert_nil cookies['user_id']
  end
end
