module PageObjects
  module Images
    class ShowPage < PageObjects::Document
      path :image
      collection :tag_elements, locator: '.card-text', item_locator: 'a'

      def image_name
        node.find('.card-header').text
      end

      def image_url
        node.find('img.card-img-bottom.card-image')[:src]
      end

      def tags
        tag_elements.map(&:text)
      end

      def delete
        node.click_on('Delete')
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!
        delete(&:accept)
        window.change_to(IndexPage)
      end

      def go_back_to_index!
        node.click_on('Image Sharer')
        window.change_to(IndexPage)
      end

      def share
        node.click_on('Share')
        share_modal = element(locator: '.js-modal', is: ShareModal)
        share_modal.wait_until_visible
        yield(share_modal)
      end
    end
  end
end
