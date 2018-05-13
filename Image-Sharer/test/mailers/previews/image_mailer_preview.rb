# Preview all emails at http://localhost:3000/rails/mailers/image_mailer
class ImageMailerPreview < ActionMailer::Preview
  def share_image
    ImageMailer.share_image('mohan.chaturvedula@appfolio.com', 'Test Message', 'https://www.appfolio.com/images/html/apm-mobile-nav2-logo.png')
  end
end
