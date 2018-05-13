module PageObjects
  module Images
    class ImageCard < AePageObjects::Element
      collection :tags_list, locator: '.js-image-tags', item_locator: 'a'

      def view!
        node.find('.js-img-link').click
        window.change_to(ShowPage)
      end

      def share!
        node.find('.js-share').click
        window.change_to(ShowPage, IndexPage)
      end

      def url
        node.find('img')[:src]
      end

      def tags
        tags_list.map(&:text)
      end

      def click_tag!(tag_name)
        IndexPage.visit(tag: tag_name)
      end

      def edit_tags!
        node.find('.js-edit-tags').click
        window.change_to(EditPage, IndexPage)
      end
    end
  end
end
