require 'flow_test_helper'
require 'create_helper'

class UsersCrudTest < FlowTestCase
  test 'login with remember and logout a user' do
    user = CreateHelper.create_user

    images_index_page = PageObjects::Images::IndexPage.visit

    images_index_page = images_index_page.logout! if images_index_page.user_name.present?

    user_login_page = images_index_page.login!
    user_login_page = user_login_page.user_login!(
      email: 'mohan.chaturvedula@appfolio.com',
      password: '',
      remember_me: '1'
    ).as_a(PageObjects::Users::LoginPage)

    assert_equal 'Invalid user/password combination', user_login_page.flash_message(:danger)

    images_index_page = user_login_page.user_login!(
      email: 'mohan.chaturvedula@appfolio.com',
      password: 'Test@123',
      remember_me: '1'
    ).as_a(PageObjects::Images::IndexPage)

    assert_equal "Welcome back, #{user.name}", images_index_page.flash_message(:success)
    assert images_index_page.register_link.absent?
    assert images_index_page.login_link.absent?
    assert images_index_page.user_name.present?

    images_index_page = PageObjects::Users::LoginPage.visit
    assert_equal 'You are already logged in', images_index_page.flash_message(:warning)

    images_outer_index_page = PageObjects::Images::IndexPage.visit

    within_window open_new_window do
      images_index_page = PageObjects::Images::IndexPage.visit
      images_index_page = images_index_page.logout!
      assert_equal 'You have successfully logged out', images_index_page.flash_message(:success)
      assert images_index_page.register_link.present?
      assert images_index_page.login_link.present?
      assert images_index_page.user_name.absent?
    end

    user_login_page = images_outer_index_page.logout!.as_a(PageObjects::Users::LoginPage)
    assert_equal 'You need to login first', user_login_page.flash_message(:warning)
    assert user_login_page.email.present?
    assert user_login_page.password.present?
  end

  test 'login without remember and logout a user' do
    user = CreateHelper.create_user

    images_index_page = PageObjects::Images::IndexPage.visit

    images_index_page = images_index_page.logout! if images_index_page.user_name.present?

    user_login_page = images_index_page.login!
    user_login_page = user_login_page.user_login!(
      email: 'mohan.chaturvedula@appfolio.com',
      password: '',
      remember_me: '0'
    ).as_a(PageObjects::Users::LoginPage)

    assert_equal 'Invalid user/password combination', user_login_page.flash_message(:danger)

    images_index_page = user_login_page.user_login!(
      email: 'mohan.chaturvedula@appfolio.com',
      password: 'Test@123',
      remember_me: '0'
    ).as_a(PageObjects::Images::IndexPage)

    assert_equal "Welcome back, #{user.name}", images_index_page.flash_message(:success)
    assert images_index_page.register_link.absent?
    assert images_index_page.login_link.absent?
    assert images_index_page.user_name.present?

    images_index_page = PageObjects::Users::LoginPage.visit
    assert_equal 'You are already logged in', images_index_page.flash_message(:warning)

    images_outer_index_page = PageObjects::Images::IndexPage.visit

    within_window open_new_window do
      images_index_page = PageObjects::Images::IndexPage.visit
      images_index_page = images_index_page.logout!
      assert_equal 'You have successfully logged out', images_index_page.flash_message(:success)
      assert images_index_page.register_link.present?
      assert images_index_page.login_link.present?
      assert images_index_page.user_name.absent?
    end

    user_login_page = images_outer_index_page.logout!.as_a(PageObjects::Users::LoginPage)
    assert_equal 'You need to login first', user_login_page.flash_message(:warning)
    assert user_login_page.email.present?
    assert user_login_page.password.present?
  end
end
