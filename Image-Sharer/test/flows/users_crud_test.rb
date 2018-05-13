require 'flow_test_helper'

class UsersCrudTest < FlowTestCase
  test 'register a user' do
    images_index_page = PageObjects::Images::IndexPage.visit

    new_user_page = images_index_page.register!

    new_user_page = new_user_page.register_user!(
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    ).as_a(PageObjects::Users::NewPage)

    assert_equal "Name can't be blank", new_user_page.name.error_message

    user_name = 'Mohan'
    new_user_page.name.set(user_name)

    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal "Email can't be blank", new_user_page.email.error_message

    user_email = 'invalid'
    new_user_page.email.set(user_email)
    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal 'Email is invalid', new_user_page.email.error_message

    user_email = 'mohan.chaturvedula@appfolio.com'
    new_user_page.email.set(user_email)
    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal "can't be blank", new_user_page.password.error_message
    assert_equal "Confirm Password can't be blank", new_user_page.password_confirmation.error_message

    user_password = 'Test'
    new_user_page.password.set(user_password)
    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal 'Password is too short', new_user_page.password.error_message

    user_password = 'Test@123'
    new_user_page.password.set(user_password)
    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal "doesn't match Password", new_user_page.password_confirmation.error_message

    user_password = 'Test@123'
    user_password_confirmation = 'Test@121'
    new_user_page.password.set(user_password)
    new_user_page.password_confirmation.set(user_password_confirmation)
    new_user_page = new_user_page.register_user!.as_a(PageObjects::Users::NewPage)
    assert_equal "doesn't match Password", new_user_page.password_confirmation.error_message

    user_password = 'Test@123'
    user_password_confirmation = user_password
    new_user_page.password.set(user_password)
    new_user_page.password_confirmation.set(user_password_confirmation)
    images_index_page = new_user_page.register_user!

    assert_equal "Welcome to Image Sharer, #{user_name}", images_index_page.flash_message(:success)

    new_user_page = PageObjects::Users::NewPage.visit

    new_user_page = new_user_page.register_user!(
      name: 'Second User',
      email: User.last.email,
      password: 'Test@1234',
      password_confirmation: 'Test@1234'
    ).as_a(PageObjects::Users::NewPage)
    assert_equal 'User already exists', new_user_page.email.error_message
  end
end
