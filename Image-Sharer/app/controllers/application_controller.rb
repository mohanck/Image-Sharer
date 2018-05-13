class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from Pundit::NotAuthorizedError do
    warning = 'Oops.. you are not authorized to perform this action'
    redirect_to(request.referer || root_url, flash: { warning: warning })
  end
end
