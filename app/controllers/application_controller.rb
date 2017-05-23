class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def validate_param
    cookies[:user_uid] ||= params[:user_uid]
    cookies[:gateway_uid] ||= params[:gateway_uid]
    cookies[:customer_uid] ||= params[:customer_uid]
    @user = User.find_by(uid: cookies[:user_uid])
    @gateway = @user.gateways&.find_by(uid: cookies[:gateway_uid])
    if Rails.env.production? && (@user.nil? || @gateway.nil? || cookies[:customer_uid].blank?
      return render plain: "ERROR: Parameters is not enough. If you don't know how to send the request, please refer http://admin.skyluster.com/docs")
    end
  end

  private

  def set_locale
  	cookies[:locale] ||= params[:locale]
    I18n.locale = cookies[:locale]
  end
end
