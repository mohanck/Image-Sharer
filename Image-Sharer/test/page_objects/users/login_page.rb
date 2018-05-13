module PageObjects
  module Users
    class LoginPage < PageObjects::Document
      path :new_session
      path :sessions
      path :root

      form_for :session do
        element :email
        element :password
        element :remember_me
      end

      def user_login!(email: nil, password: nil, remember_me: nil)
        self.email.set(email)
        self.password.set(password)
        remember_me == '1' ? self.remember_me.set(true) : self.remember_me.set(false)
        node.click_button('Log In')
        window.change_to(PageObjects::Images::IndexPage, self.class)
      end
    end
  end
end
