require 'test_helper'

class ImagePolicyTest < ActiveSupport::TestCase
  setup do
    user = mock
    @image = mock(user: user)
    @image_policy = create_image_policy(user, @image)
  end

  test 'edit returns true if user is owner of image' do
    assert_predicate @image_policy, :edit?
  end

  test 'update returns true if user is owner of image' do
    assert_predicate @image_policy, :update?
  end

  test 'delete returns true if user is owner of image' do
    assert_predicate @image_policy, :destroy?
  end

  test 'edit returns false if user is non-owner of image' do
    image_policy = create_image_policy(mock, @image)
    refute_predicate image_policy, :edit?
  end

  test 'update returns false if user is non-owner of image' do
    image_policy = create_image_policy(mock, @image)
    refute_predicate image_policy, :update?
  end

  test 'delete returns false if user is non-owner of image' do
    image_policy = create_image_policy(mock, @image)
    refute_predicate image_policy, :destroy?
  end

  private

  def create_image_policy(user, image)
    ImagePolicy.new(user, image)
  end
end
