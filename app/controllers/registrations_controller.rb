class RegistrationsController < Devise::RegistrationsController

  private

  def after_sign_up_path_for(resource)
    bankin_path
  end

  def after_sign_in_path_for(user)
    svg_path #-->redirect ro savings page
  end

end
