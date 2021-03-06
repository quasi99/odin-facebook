class ApplicationController < ActionController::Base
	before_action :authenticate_user!, except: :about
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  REQUESTING_FRIENDS_IDS = [1, 7, 11, 22, 24, 29, 35, 37, 39, 45, 55, 61]

  def create_friend_invitations
    REQUESTING_FRIENDS_IDS.each do |requester_id|
      friend_request = @user.friend_invitations.build(requester_id: requester_id)
      friend_request.save
    end
  end

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_now
  end
end
