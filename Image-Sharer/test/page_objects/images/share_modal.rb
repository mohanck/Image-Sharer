module PageObjects
  module Images
    class ShareModal < AePageObjects::Element
      form_for :share_form do
        element :email
        element :message
      end

      def modal_title
        node.find('.js-modal-title').text
      end

      def modal_image_url
        node.find('img.js-image')[:src]
      end

      def modal_close_button_text
        node.find('.js-modal-close').text
      end

      def modal_send_email
        node.click_on('Send Email')
      end
    end
  end
end
