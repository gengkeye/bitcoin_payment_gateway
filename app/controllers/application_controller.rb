class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def validate_param
    @user = User.find_by(app_id: params[:app_id])
    @gateway = @user&.gateways&.find_by(hashed_id: params[:gateway_hashed_id])

    cookies[:user_id] = @user&.id ||  cookies[:user_id]
    cookies[:gateway_id] = @gateway&.id || cookies[:gateway_id]
    cookies[:customer_uid] =  params[:customer_uid]|| cookies[:customer_uid]
  
    if Rails.env.production? && (@user.nil? || @gateway.nil? || cookies[:customer_uid].blank?)
      return render plain: t("errors.params_error") 
    end
  end

  def validate_secret
    unless StraightServerKit.valid_callback?(signature: ENV['HTTP_X_SIGNATURE'], request_uri: (URI(ENV['REQUEST_URI']).request_uri \
              rescue ENV['REQUEST_URI']), secret: ENV['SECRET_KEY_BASE'])
      return render plain: t("errors.signature_error") 
    end
  end

  private

  def set_locale
  	cookies[:locale] ||= params[:locale]
    I18n.locale = cookies[:locale]
  end
end
