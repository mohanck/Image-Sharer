require 'flow_test_helper'
require 'login_helper'
require 'create_helper'

class ImagesCrudTest < FlowTestCase
  setup do
    @user = CreateHelper.create_user
  end

  test 'add an image' do
    LoginHelper.login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')

    images_index_page = PageObjects::Images::IndexPage.visit

    new_image_page = images_index_page.add_new_image!

    new_image_page = new_image_page.create_image!(
      name: '',
      url: '',
      tags: ''
    ).as_a(PageObjects::Images::NewPage)

    assert_equal "Image Name can't be blank", new_image_page.title.error_message

    image_name = 'Mind Blown'
    new_image_page.title.set(image_name)

    new_image_page = new_image_page.create_image!.as_a(PageObjects::Images::NewPage)
    assert_equal "Image URL can't be blank", new_image_page.url.error_message

    image_url = 'invalid'
    new_image_page.url.set(image_url)
    new_image_page = new_image_page.create_image!.as_a(PageObjects::Images::NewPage)
    assert_equal 'Image URL is invalid', new_image_page.url.error_message

    image_url = 'https://media3.giphy.com/media/EldfH1VJdbrwY/200.gif'
    new_image_page.url.set(image_url)

    new_image_page = new_image_page.create_image!.as_a(PageObjects::Images::NewPage)
    assert_equal 'Image needs to have at least one tag', new_image_page.tag_list.error_message

    tags = %w(foo bar)
    new_image_page.tag_list.set(tags.join(','))
    image_show_page = new_image_page.create_image!
    assert_equal 'Image uploaded successfully', image_show_page.flash_message(:success)

    assert_equal image_url, image_show_page.image_url
    assert_equal tags, image_show_page.tags

    images_index_page = image_show_page.go_back_to_index!
    assert images_index_page.showing_image?(url: image_url, tags: tags)
  end

  test 'delete an image' do
    LoginHelper.login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')

    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    ugly_cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'

    Image.create!([
      { title: 'Puppy', url: cute_puppy_url, tag_list: 'puppy, cute', user: @user },
      { title: 'Cat', url: ugly_cat_url, tag_list: 'cat, ugly', user: @user }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    assert_equal 2, images_index_page.images.count
    assert images_index_page.showing_image?(url: ugly_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)

    image_to_delete = images_index_page.images.find do |image|
      image.url == ugly_cat_url
    end
    # Remember that image_to_delete var contains an image to be deleted

    image_show_page = image_to_delete.view!

    image_show_page.delete do |confirm_dialog|
      assert_equal 'Do you want to delete this image?', confirm_dialog.text
      confirm_dialog.dismiss
    end

    images_index_page = image_show_page.delete_and_confirm!
    assert_equal 'You have successfully deleted the image', images_index_page.flash_message(:success)

    assert_equal 1, images_index_page.images.count
    refute images_index_page.showing_image?(url: ugly_cat_url)
    assert images_index_page.showing_image?(url: cute_puppy_url)
  end

  test 'view images associated with a tag' do
    puppy_url_1 = 'http://www.pawderosa.com/images/puppies.jpg'
    puppy_url_2 = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'
    Image.create!([
      { title: 'Puppy 1', url: puppy_url_1, tag_list: 'superman, cute', user: @user },
      { title: 'Puppy 2', url: puppy_url_2, tag_list: 'cute, puppy', user: @user },
      { title: 'Cat', url: cat_url, tag_list: 'cat, ugly', user: @user }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit

    [puppy_url_1, puppy_url_2, cat_url].each do |url|
      assert images_index_page.showing_image?(url: url)
    end

    images_index_page = images_index_page.images[1].click_tag!('cute')

    assert_equal 2, images_index_page.images.count
    refute images_index_page.showing_image?(url: cat_url)

    images_index_page = images_index_page.clear_tag_filter!
    assert_equal 3, images_index_page.images.count
  end

  test 'edit tags associated with an image' do
    LoginHelper.login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    puppy_url = 'http://www.pawderosa.com/images/puppies.jpg'

    CreateHelper.create_image(title: 'Puppy', url: puppy_url, tag_list: 'puppy, cute', user: @user)

    images_index_page = PageObjects::Images::IndexPage.visit

    assert images_index_page.showing_image?(url: puppy_url)

    image_edit_page = images_index_page.images[0].edit_tags!

    name = 'Sleeping Puppy'
    tags = %w(puppy cute sleeping)

    image_show_page = image_edit_page.edit_image!(
      name: name,
      tags: tags.join(', ')
    ).as_a(PageObjects::Images::ShowPage)

    assert_equal 'Image Attributes changed successfully', image_show_page.flash_message(:success)
    assert_equal tags, image_show_page.tags
    assert_equal name, image_show_page.image_name
  end
end
