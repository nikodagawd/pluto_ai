class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_get_started_path_for(resource)
    root_path
  end
end
