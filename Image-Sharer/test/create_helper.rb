module CreateHelper
  def self.create_user(name: 'Mohan', email: 'mohan.chaturvedula@appfolio.com', password: 'Test@123')
    User.create!(name: name, email: email, password: password, password_confirmation: password)
  end

  def self.create_image(title: 'Image 1', url: 'https://www.appfolio.com/images/html/apm-mobile-nav2-logo.png',
                        tag_list: 'Awesome', user: nil)
    Image.create!(title: title, url: url, tag_list: tag_list, user: user)
  end
end
