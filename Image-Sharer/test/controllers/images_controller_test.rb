require 'test_helper'
require 'create_helper'
class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = CreateHelper.create_user
    @image = CreateHelper.create_image(user: @user)
    ImagesController.any_instance.stubs(:user_authenticated?).returns(true)
  end

  test 'index should contain images in reverse order and link to upload page' do
    login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    images = Image.order(created_at: :desc)
    get root_url
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select 'img', count: images.size do |img_tag_elements|
      img_tag_elements.each_with_index do |img_tag_element, index|
        assert_equal images[index].url, img_tag_element.attributes['src'].value
      end
    end
    assert_select 'a', href: '/images/new', text: 'Upload'
    assert_select 'span', class: 'text', text: /AppFolio.com/
  end

  test 'index should contain 20 images' do
    Image.create(
      [
        { title: 'Image 1',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6601.jpg',
          tag_list: 'Awesome', created_at: 20.minutes.ago, user: @user },
        { title: 'Image 2',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6602.jpg',
          tag_list: 'Awesome', created_at: 19.minutes.ago, user: @user },
        { title: 'Image 3',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6603.jpg',
          tag_list: 'Awesome', created_at: 18.minutes.ago, user: @user },
        { title: 'Image 4',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6604.jpg',
          tag_list: 'Awesome', created_at: 17.minutes.ago, user: @user },
        { title: 'Image 5',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6625.jpg',
          tag_list: 'Awesome', created_at: 16.minutes.ago, user: @user },
        { title: 'Image 6',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6621.jpg',
          tag_list: 'Awesome', created_at: 15.minutes.ago, user: @user },
        { title: 'Image 7',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6623.jpg',
          tag_list: 'Awesome', created_at: 14.minutes.ago, user: @user },
        { title: 'Image 8',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6608.jpg',
          tag_list: 'Awesome', created_at: 13.minutes.ago, user: @user },
        { title: 'Image 9',  url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6609.jpg',
          tag_list: 'Awesome', created_at: 12.minutes.ago, user: @user },
        { title: 'Image 10', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6624.jpg',
          tag_list: 'Awesome', created_at: 11.minutes.ago, user: @user },
        { title: 'Image 11', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6611.jpg',
          tag_list: 'Awesome', created_at: 10.minutes.ago, user: @user },
        { title: 'Image 12', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6612.jpg',
          tag_list: 'Awesome', created_at: 9.minutes.ago, user: @user },
        { title: 'Image 13', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6613.jpg',
          tag_list: 'Awesome', created_at: 8.minutes.ago, user: @user },
        { title: 'Image 14', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6614.jpg',
          tag_list: 'Awesome', created_at: 7.minutes.ago, user: @user },
        { title: 'Image 15', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6615.jpg',
          tag_list: 'Awesome', created_at: 6.minutes.ago, user: @user },
        { title: 'Image 16', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6616.jpg',
          tag_list: 'Awesome', created_at: 5.minutes.ago, user: @user },
        { title: 'Image 17', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6621.jpg',
          tag_list: 'Awesome', created_at: 4.minutes.ago, user: @user },
        { title: 'Image 18', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6618.jpg',
          tag_list: 'Awesome', created_at: 3.minutes.ago, user: @user },
        { title: 'Image 19', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6619.jpg',
          tag_list: 'Awesome', created_at: 2.minutes.ago, user: @user }
      ]
    )
    get root_url
    assert_response :ok
    assert_equal 20, Image.count
  end

  test 'index displays properly with no images' do
    Image.destroy_all
    get root_url
    assert_response :ok
  end

  test 'index contains image with tags' do
    Image.create!(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                  tag_list: %w(Hyundai Blue), user: @user)
    get root_url
    assert_response :ok
    assert_select 'div', class: 'text-capitalize tag-header', text: 'Tags'
    assert_select 'img', class: 'card-image'
  end

  test 'index contains image with selected tags' do
    Image.create!(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                  tag_list: %w(Hyundai Blue), user: @user)
    get images_url, params: { tag: 'Blue' }
    assert_response :ok
    assert_select 'div', class: 'text-capitalize', text: 'Tags'
    assert_select 'a', text: 'Blue'
  end

  test 'index contains image with linkable tags' do
    Image.create!(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                  tag_list: %w(Hyundai Blue), user: @user)
    get images_url
    assert_response :ok
    assert_select 'div', class: 'text-capitalize', text: 'Tags'
    assert_select 'a', text: 'Blue'
    assert_select 'a', text: 'Hyundai'
  end

  test 'index contains displays error image with invalid tags' do
    Image.create!(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                  tag_list: %w(Hyundai Blue), user: @user)
    get images_url, params: { tag: 'Green' }
    assert_response :ok
    assert_select 'div', class: 'text-muted text-center', text: 'No images exist with tag - Green'
  end

  test 'index contains displays error image with no tags' do
    Image.create!(title: 'Image 21', url: 'http://buyersguide.caranddriver.com/media/assets/submodel/6631.jpg',
                  tag_list: %w(Hyundai Blue), user: @user)
    get images_url, params: { tag: '' }
    assert_response :ok
    assert_select 'div', class: 'text-muted text-center', text: 'Tag cannot be empty'
  end

  test 'index contains image with delete button' do
    login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    get root_url
    assert_response :ok
    assert_select 'div', class: 'card-footer'
    assert_select 'input[type=\'submit\'][value=\'Delete\']', class: 'btn btn-outline-danger btn-sm'
  end

  test 'create should redirect to show' do
    login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    post images_url, params: {
      image: { title: 'Image 2', url: 'https://www.appfolio.com/images/html/apm-mobile-nav2-logo.png',
               tag_list: 'Awesome' }
    }
    image_cur = Image.last
    assert_redirected_to image_url(image_cur) if image_cur.valid?
  end

  test 'create should render to upload when we enter invalid data' do
    post images_url, params: {
      image: { title: 'Image 2' }
    }
    assert_response :unprocessable_entity
  end

  test 'new should contain text boxes' do
    get new_image_url
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select "form[action='#{images_path}']"
    assert_select 'label[for=image_title]', text: '* Image Name'
    assert_select 'input[id=image_title][name=\'image[title]\']'
    assert_select 'label[for=image_url]', text: '* Image URL'
    assert_select 'input[id=image_tag_list][name=\'image[tag_list]\']'
    assert_select 'label[for=image_tag_list]', text: '* Image Tags'
    assert_select 'input[type=\'submit\'][value=\'Upload Image\']'
    assert_select 'span', class: 'text', text: /AppFolio.com/
  end

  test 'show should contain image' do
    get image_url(@image.id)
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select 'img', src: @image.url
    assert_select 'span', class: 'text', text: /AppFolio.com/
  end

  test 'delete should remove image and redirect to index' do
    turn_on_policy('destroy?')
    assert_difference 'Image.count', -1 do
      delete image_url(@image)
    end
    assert_not Image.exists?(@image.id)
    assert_redirected_to root_url
  end

  test 'delete displays flash message if image does not exist' do
    assert_difference 'Image.count', 0 do
      delete image_url(-1)
    end
    assert_predicate flash[:danger], :present?
    assert_response :not_found
  end

  test 'share displays image, email and message inputs' do
    get share_image_url(@image)
    assert_response :ok
    assert_select 'img', src: @image.url
    assert_select 'input[placeholder=\'first.last@example.com\']', class: 'js-email'
    assert_select 'input[placeholder=\'Enter message here\']', class: 'js-message'
    assert_select 'input[type=\'submit\'][value=\'Send Email\']'
  end

  test 'send_email sends email' do
    post send_email_image_url(@image.id), params: { id: @image.id, share_form:
                                          {
                                            email: 'mohan.chaturvedula@appfolio.com',
                                            message: 'Test Message'
                                          } }
    mail = ActionMailer::Base.deliveries.last
    mail_body = mail.body.parts.last.to_s
    assert_equal 'donotreply_ropes@appfolio.com', mail.from.first, 'Invalid Recipient'
    assert_equal 'mohan.chaturvedula@appfolio.com', mail.to.first, 'Invalid Sender'
    assert_equal 'Share Image Email', mail.subject, 'Invalid Subject'
    assert_match %r{<img src="#{@image.url}" alt="Apm mobile nav2 logo" />}o, mail_body, 'Invalid Body'
    assert mail_body['Message : Test Message'], 'Invalid Body'
    assert_predicate flash[:success], :present?
    assert_equal "Image shared with #{mail.to.first}", flash[:success].to_s, 'Invalid message'
    assert_response :ok
  end

  test 'send_email displays flash message if Image does not exist' do
    Image.destroy(@image.id)
    post send_email_image_url(@image.id), params: { id: @image.id, share_form:
                                          {
                                            email: 'mohan.chaturvedula@appfolio.com',
                                            message: 'Test Message'
                                          } }
    assert_predicate flash.now[:danger], :present?
    assert_equal 'Oops.. Image you are trying to share does not exist', flash[:danger].to_s, 'Invalid message'
    assert_response :not_found
  end

  test 'send_email displays error if email field in form is invalid' do
    post send_email_image_url(@image.id), params: { id: @image.id, share_form:
      {
        email: 'first.last',
        message: 'Test Message'
      } }, xhr: true
    assert_includes response.body, 'Invalid Email format'
    assert_response :unprocessable_entity
  end

  test 'send_email displays error if email field in form is empty' do
    post send_email_image_url(@image.id), params: { id: @image.id, share_form:
      {
        email: '',
        message: 'Test Message'
      } }, xhr: true
    assert_includes response.body, 'Email can&#39;t be blank'
    assert_response :unprocessable_entity
  end

  test 'edit displays form for editing' do
    turn_on_policy('update?')
    get edit_image_url(@image.id)
    assert_response :ok
    assert_select 'ul', class: 'navbar-nav mr-auto'
    assert_select ".test-edit-image-form[action='#{image_path(@image.id)}']"
    assert_select ".test-edit-image-img[src='#{@image.url}']"
    assert_select 'label[for=image_title]', text: '* Image Name'
    assert_select '.test-edit-image-title'
    assert_select 'label[for=image_tag_list]', text: '* Image Tags'
    assert_select '.test-edit-image-tag-list'
    assert_select '.test-image-edit-submit[value=\'Update Image\']'
    assert_select 'span.text', text: /AppFolio.com/
  end

  test 'update should change image attributes for long tags with spaces' do
    turn_on_policy('update?')
    tag_list = 'Happiness Celebrate Adventure, b bb bbb bbbb bbbbb bbbbbb'
    put image_url(@image.id), params: {
      image: { title: 'Image 2', tag_list: tag_list }
    }
    image = Image.find(@image.id)
    assert_equal 'Image 2', image.title
    assert_equal tag_list.split(', '), image.tag_list
    assert_equal 'Image Attributes changed successfully', flash[:success]
    assert_not_equal image.created_at, image.updated_at
    assert_select '.form-control-feedback', false, 'No errors'
    assert_redirected_to image_url(image)
  end

  test 'update should change image attributes for long tags without spaces' do
    turn_on_policy('update?')
    tag_list = 'pseudopseudohypoparathyroidism, floccinaucinihilipilification'
    put image_url(@image.id), params: {
      image: { title: 'Image 2', tag_list: tag_list }
    }
    image = Image.find(@image.id)
    assert_equal 'Image 2', image.title
    assert_equal tag_list.split(', '), image.tag_list
    assert_equal 'Image Attributes changed successfully', flash[:success]
    assert_not_equal image.created_at, image.updated_at
    assert_select '.form-control-feedback', false, 'No errors'
    assert_redirected_to image_url(image)
  end

  test 'update should render to edit if there are too many tags' do
    turn_on_policy('update?')
    tags = ''
    (1..50).each do |num|
      tags << "tag#{num},"
    end
    tags << 'tag51'

    put image_url(@image.id), params: {
      image: { title: 'Image 2', tag_list: tags }
    }
    image = Image.find(@image.id)
    assert_not_equal 'Image 2', image.title
    assert_equal 'Image 1', image.title
    assert_not_equal tags.split(' ,'), image.tag_list
    assert_equal ['Awesome'], image.tag_list
    assert_select '.form-control-feedback', text: 'Too many tags'
    assert_response :unprocessable_entity
  end

  test 'update should render to edit if tag is super long' do
    turn_on_policy('update?')
    tag = 'pneumonoultramicroscopicsilicovolcanoconiosis'
    put image_url(@image.id), params: {
      image: { title: 'Image 2', tag_list: tag }
    }
    image = Image.find(@image.id)
    assert_not_equal 'Image 2', image.title
    assert_equal 'Image 1', image.title
    assert_not_equal tag.split(' ,'), image.tag_list
    assert_equal ['Awesome'], image.tag_list
    assert_select '.form-control-feedback', text: "Tag - #{tag} is longer than 30 characters"
    assert_response :unprocessable_entity
  end

  test 'update should render to edit if Image Name is empty' do
    turn_on_policy('update?')
    put image_url(@image.id), params: {
      image: { title: '', tag_list: 'Awesome, Sedan' }
    }
    image = Image.find(@image.id)
    assert_not_equal '', image.title
    assert_equal 'Image 1', image.title
    assert_not_equal %w(Awesome Sedan), image.tag_list
    assert_equal ['Awesome'], image.tag_list
    assert_select '.form-control-feedback', text: "Image Name can't be blank"
    assert_response :unprocessable_entity
  end

  test 'update should render to edit if Image Tags List is invalid' do
    turn_on_policy('update?')
    tag = ',  ,,,,,,,,'
    put image_url(@image.id), params: {
      image: { title: 'Image 2', tag_list: tag }
    }
    image = Image.find(@image.id)
    assert_not_equal 'Image 2', image.title
    assert_equal 'Image 1', image.title
    assert_not_equal tag.split(' ,'), image.tag_list
    assert_equal ['Awesome'], image.tag_list
    assert_select '.form-control-feedback', text: 'Image needs to have at least one tag'
    assert_response :unprocessable_entity
  end

  test 'update should render to edit if Image Name and Image Tags List is empty' do
    turn_on_policy('update?')
    put image_url(@image.id), params: {
      image: { title: '', tag_list: '' }
    }
    image = Image.find(@image.id)
    assert_not_equal '', image.title
    assert_equal 'Image 1', image.title
    assert_not_equal '', image.tag_list
    assert_equal ['Awesome'], image.tag_list
    assert_select '.form-control-feedback', text: "Image Name can't be blank"
    assert_select '.form-control-feedback', text: 'Image needs to have at least one tag'
    assert_response :unprocessable_entity
  end

  test 'links to non-read actions are not shown to logged out users' do
    get images_url
    assert_response :ok
    assert_select ".nav-link[value='Upload']", false
    assert_select '.js-edit-tags', false
    assert_select '.js-delete', false
    assert_select '.js-share', false
    assert_select '.js-img-link'
    assert_select '.card-tag'
    assert_select 'a', text: 'Awesome'
  end

  test 'sharing an image requires login' do
    ImagesController.any_instance.unstub(:user_authenticated?)
    get share_image_url(@image.id)
    assert_redirected_to new_session_path
    assert_equal 'You need to login', flash[:warning]
  end

  test 'non-logged user sharing an image redirects to login and back to index' do
    ImagesController.any_instance.unstub(:user_authenticated?)
    get share_image_url(@image.id)
    assert_redirected_to new_session_path
    login_as(email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    assert_redirected_to share_image_url(@image)
  end

  test 'deleting an image requires user to be uploader' do
    ImagePolicy.any_instance.unstub(:destroy?)
    @user = CreateHelper.create_user(name: 'Krishna', email: 'mohan.chaturvedula@gmail.com')
    login_as(email: 'mohan.chaturvedula@gmail.com', password: 'Test@123')
    assert_no_difference 'Image.count' do
      delete image_url(@image.id)
      assert_redirected_to root_url
      assert_equal 'Oops.. you are not authorized to perform this action', flash[:warning]
    end
  end

  test 'uploader can delete image' do
    login_as(email: @user.email, password: 'Test@123')
    delete image_url(@image.id)
    assert_redirected_to root_url
    assert_equal 'You have successfully deleted the image', flash[:success]
  end

  test 'non-uploader cannot view delete image link' do
    ImagePolicy.any_instance.unstub(:destroy?)
    user = CreateHelper.create_user(name: 'Krishna', email: 'mohan.chaturvedula@gmail.com')
    login_as(email: user.email, password: 'Test@123')
    get images_url
    assert_select '.test-logged-user', text: user.name
    assert_select '.js-delete', false
    assert_select '.js-share', 1
    assert_select '.js-card-image', 1
  end

  private

  def login_as(email: nil, password: nil, remember_me: '0')
    post sessions_url, params: {
      session: { email: email, password: password, remember_me: remember_me }
    }
  end

  def turn_on_policy(policy)
    ImagePolicy.any_instance.stubs(policy.to_sym).returns(true)
  end
end
