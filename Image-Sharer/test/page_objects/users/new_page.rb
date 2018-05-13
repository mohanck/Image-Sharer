module PageObjects
  module Users
    class NewPage < PageObjects::Document
      path :new_user
      path :users

      form_for :user do
        element :name
        element :email
        element :password
        element :password_confirmation
      end

      def register_user!(name: nil, email: nil, password: nil, password_confirmation: nil)
        self.name.set(name) if name.present?
        self.email.set(email) if email.present?
        self.password.set(password) if password.present?
        self.password_confirmation.set(password_confirmation) if password_confirmation.present?
        node.click_button('Register')
        window.change_to(PageObjects::Images::IndexPage, self.class)
      end
    end
  end
end
