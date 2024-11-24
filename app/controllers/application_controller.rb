class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:username, :avatar_url])

    devise_parameter_sanitizer.permit(:account_update, :keys => [:username, :avatar_url])
  end

  def destroy
    sign_out(current_user)
  #  redirect_to root_path, notice: 'You have been signed out.'
  redirect_to("/", { :notice => "Board deleted successfully."} )
  end
end
