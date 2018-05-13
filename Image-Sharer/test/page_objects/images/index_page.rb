module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      element :register_link, locator: '.test-user-register'
      element :login_link, locator: '.test-user-login'
      element :user_name, locator: '.test-logged-user' do
        def click_dropdown
          node.click
        end
      end
      element :logout_link, locator: '.test-user-logout'

      collection :images, locator: '.js-images', item_locator: '.js-card-image', contains: ImageCard

      def add_new_image!
        node.click_on('Upload')
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        images.any? { |image| image.url == url && (tags.blank? || image.tags == tags) }
      end

      def clear_tag_filter!
        IndexPage.visit
      end

      def register!
        node.click_on('Register')
        window.change_to(PageObjects::Users::NewPage)
      end

      def login!
        node.click_on('Log In')
        window.change_to(PageObjects::Users::LoginPage)
      end

      def dropdown_click
        user_name.present?
        user_name.click_dropdown
      end

      def logout!
        dropdown_click
        node.click_on('Log Out')
        window.change_to(PageObjects::Images::IndexPage, PageObjects::Users::LoginPage)
      end
    end
  end
end
