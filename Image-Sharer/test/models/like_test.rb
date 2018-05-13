require 'test_helper'
require 'create_helper'

class LikeTest < ActiveSupport::TestCase
  def test_like_validates_presence_of_valid_user_and_image
    user = CreateHelper.create_user
    image = CreateHelper.create_image(user: user)
    like = Like.new(user: user, image: image)
    assert like.valid?
    assert_equal [], like.errors[:user]
    assert_equal [], like.errors[:image]
    assert_equal [], like.errors[:image_id]
  end

  def test_image_validates_presence_of_valid_user
    user_ids = [nil, '', -1]
    user_ids.each do |user_id|
      like = Like.new(user_id: user_id)
      refute_predicate like, :valid?
      assert_equal ['must exist'], like.errors[:user]
    end
  end

  def test_image_validates_presence_of_valid_image
    image_ids = [nil, '', -1]
    image_ids.each do |image_id|
      like = Like.new(image_id: image_id)
      refute_predicate like, :valid?
      assert_equal ['must exist'], like.errors[:image]
    end
  end

  def test_like_validates_uniqueness_of_user_and_image
    user = CreateHelper.create_user
    image = CreateHelper.create_image(user: user)
    Like.create!(user: user, image: image)
    like_dup = Like.new(user: user, image: image)

    refute_predicate like_dup, :valid?
    assert_equal ['Like already exists'], like_dup.errors[:image_id]
  end
end
