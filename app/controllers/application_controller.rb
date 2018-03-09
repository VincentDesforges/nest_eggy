class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    svg_path #-->redirect ro savings page
  end

  def after_sign_up_path_for(user)
    request.referrer
  end
end
