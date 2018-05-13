module LoginHelper
  def self.login_as(email: nil, password: nil, remember_me: '0')
    images_index_page = PageObjects::Images::IndexPage.visit

    images_index_page = images_index_page.logout! if images_index_page.user_name.present?

    user_login_page = images_index_page.login!

    user_login_page.user_login!(
      email: email,
      password: password,
      remember_me: remember_me
    ).as_a(PageObjects::Images::IndexPage)
  end
end
