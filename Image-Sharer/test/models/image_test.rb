require 'test_helper'
require 'create_helper'

class ImageTest < ActiveSupport::TestCase
  def test_image_validates_presence_of_title_and_url_and_tags_and_user
    user = CreateHelper.create_user
    image = Image.new(title: 'Image 1', url: 'https://www.appfolio.com/images/html/apm-mobile-nav2-logo.png',
                      tag_list: 'Awesome')
    image.add_user_association(user.id)
    assert image.valid?
    assert_equal [], image.errors[:title]
    assert_equal [], image.errors[:url]
    assert_equal [], image.errors[:tag_list]
    assert_equal [], image.errors[:user]
  end

  def test_image_validates_presence_of_title
    image = Image.new(title: nil)
    image.valid?

    assert_equal ["Image Name can't be blank"], image.errors[:title]
  end

  def test_image_validates_presence_of_url
    image = Image.new(url: nil)
    image.valid?

    assert_equal ["Image URL can't be blank", 'Image URL is invalid'], image.errors[:url]
  end

  def test_image_validates_presence_of_tags
    image = Image.new(tag_list: nil)
    image.valid?

    assert_equal ['Image needs to have at least one tag'], image.errors[:tag_list]
  end

  def test_image_validates_presence_of_valid_user
    user_ids = [nil, '', -1]
    user_ids.each do |user_id|
      image = Image.new(user_id: user_id)
      image.valid?
      assert_equal ['must exist'], image.errors[:user]
    end
  end

  def test_image_validates_format_of_url
    user = CreateHelper.create_user
    images = [
      Image.new(title: 'Image 0', url: 'https://www.appfolio.com/images/html/apm-mobile-nav2-logo.png',
                tag_list: 'Awesome', user: user),
      Image.new(title: 'Image 1', url: 'hadadas', tag_list: 'Awesome'),
      Image.new(title: 'Image 2', url: 'ftp://google.com/image.jpg', tag_list: 'Awesome'),
      Image.new(title: 'Image 3', url: 'http://.jpg', tag_list: 'Awesome'),
      Image.new(title: 'Image 4', url: 'http://wrong', tag_list: 'Awesome')
    ]
    images.each do |i|
      assert_equal ['Image URL is invalid'], i.errors[:url] unless i.valid?
    end
  end

  def test_image_contains_tags
    image = Image.new(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                      tag_list: 'Hyundai, Blue')
    user = CreateHelper.create_user
    image.add_user_association(user.id)
    assert_predicate image, :valid?
    assert_equal %w(Hyundai Blue), image.tag_list
  end

  def test_image_validates_number_of_tags
    tag_list = ''
    (1..50).each do |num|
      tag_list << "tag#{num},"
    end
    tag_list << 'tag51'
    image = Image.new(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                      tag_list: tag_list)

    refute_predicate image, :valid?
    assert_equal ['Too many tags'], image.errors[:tag_list]
  end

  def test_image_validates_length_of_tags
    tag_list = 'Awesome, Appfolio, Sedan, pneumonoultramicroscopicsilicovolcanoconiosis'
    image = Image.new(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                      tag_list: tag_list)

    refute_predicate image, :valid?
    assert_equal ['Tag - pneumonoultramicroscopicsilicovolcanoconiosis is longer than 30 characters'],
                 image.errors[:tag_list]
  end
end
