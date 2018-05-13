require 'test_helper'

class LikeControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_like_url
    assert_redirected_to root_url
  end

end
