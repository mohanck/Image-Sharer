module PageObjects
  module Images
    class EditPage < PageObjects::Document
      path :edit_image
      path :image

      form_for :image do
        element :title
        element :tag_list
      end

      def edit_image!(name: nil, tags: nil)
        title.set(name)
        tag_list.set(tags)
        node.click_button('Update Image')
        window.change_to(ShowPage, self.class)
      end
    end
  end
end
