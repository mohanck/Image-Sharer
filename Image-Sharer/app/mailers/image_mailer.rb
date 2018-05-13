class ImageMailer < ApplicationMailer
  default from: 'donotreply_ropes@appfolio.com'

  def share_image(email, message, url)
    @url = url
    @msg = message
    mail(to: email, subject: 'Share Image Email', template_name: 'share_image')
  end

  layout 'mailer'
end
