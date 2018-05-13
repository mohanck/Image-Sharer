require 'flow_test_helper'
require 'login_helper'
require 'create_helper'

class ImagesShareTest < FlowTestCase
  test 'share an image' do
    user = CreateHelper.create_user

    LoginHelper.login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')

    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'

    cute_puppy_image = CreateHelper.create_image(title: 'Puppy', url: cute_puppy_url,
                                                 tag_list: 'puppy, cute', user: user)

    outer_images_index_page = PageObjects::Images::IndexPage.visit

    email = 'mohan.chaturvedula@appfolio.com'

    within_window open_new_window do
      images_index_page = PageObjects::Images::IndexPage.visit

      image_to_share = images_index_page.images.find do |image|
        image.url == cute_puppy_url
      end

      image_show_page = image_to_share.view!
      image_show_page.share do |modal|
        assert_equal 'Share Image', modal.modal_title
        assert_equal 'Close', modal.modal_close_button_text
        assert_equal cute_puppy_url, modal.modal_image_url
        modal.modal_send_email
        assert_equal "Email can't be blank", modal.email.error_message
        modal.email.set('first.last')
        modal.modal_send_email
        assert_equal 'Invalid Email format', modal.email.error_message
        modal.email.set(email)
        modal.modal_send_email
      end

      assert_equal "Image shared with #{email}", image_show_page.flash_message(:success)
    end

    image_to_share = outer_images_index_page.images.find do |image|
      image.url == cute_puppy_url
    end

    Image.destroy(cute_puppy_image.id)

    image_index_page = image_to_share.share!.as_a(PageObjects::Images::IndexPage)
    assert_equal 'Oops.. Image you are trying to share does not exist', image_index_page.flash_message(:danger)
  end
end
