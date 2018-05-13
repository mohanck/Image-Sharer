module PageObjects
  module Images
    class NewPage < PageObjects::Document
      path :new_image
      path :images

      form_for :image do
        element :title
        element :url
        element :tag_list
      end

      def create_image!(name: nil, url: nil, tags: nil)
        title.set(name) if name.present?
        self.url.set(url) if url.present?
        tag_list.set(tags) if tags.present?
        node.click_button('Upload Image')
        window.change_to(ShowPage, self.class)
      end
    end
  end
end
