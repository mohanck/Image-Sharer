require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'new should contain form elements' do
    get new_user_url
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select ".test-user-form[action='#{users_path}']"
    assert_select 'label[for=user_name]', text: '* Name'
    assert_select '.test-user-name'
    assert_select 'label[for=user_email]', text: '* Email'
    assert_select '.test-user-email'
    assert_select 'label[for=user_password]', text: '* Password'
    assert_select '.test-user-password'
    assert_select 'label[for=user_password_confirmation]', text: '* Confirm Password'
    assert_select '.test-user-confirm-password'
    assert_select '.test-user-submit[value=\'Register\']'
    assert_select 'span.text', text: /AppFolio.com/
  end

  test 'create should redirect to root when we enter valid data' do
    assert_difference 'User.count', 1 do
      post users_url, params: {
        user: { name: 'Mohan', email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123',
                password_confirmation: 'Test@123' }
      }
    end
    assert_equal 'Welcome to Image Sharer, Mohan', flash[:success]
    assert_redirected_to root_url
  end

  test 'create should render to register when we enter invalid data' do
    assert_no_difference 'User.count' do
      post users_url, params: {
        user: { name: 'Mohan', email: 'mohan.chaturvedula@appfolio.com' }
      }
    end
    assert_response :unprocessable_entity
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select ".test-user-form[action='#{users_path}']"
    assert_select '.password .form-control-feedback', text: "can't be blank"
    assert_select '.user_password_confirmation .form-control-feedback', text: "Confirm Password can't be blank"
    assert_select 'span.text', text: /AppFolio.com/
  end
end
