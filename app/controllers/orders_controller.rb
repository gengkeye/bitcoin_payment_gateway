class OrdersController < ApplicationController
  before_action :validate_secret, only: [:new, :payment_callback], if: -> { Rails.env.production? }
  before_action :validate_param, only: [:new, :create]
  before_action :set_client, only: [:create]

  def new
    @sub_title = 'pay_with_bitcoin'
    @form_path = "#{request.original_url}/orders"
    @btn_name = 'pay_btn'
  end

  def update
    @order = Order.find_by(uid: params[:id])
  	begin
	  	@order.update status: 'canceled'
	  	return redirect_to :index
  	rescue
  		return render :failed, locals: { error_info: "ERROR: This order cannot be canceled now. Please try again later." }
  	end
  end

  def create
    if params[:amount_of_btc].blank? || params[:amount_of_cny].blank?
      return render :failed, locals: { error_info: "ERROR: lack of params." }
    end
    begin
      # res = HTTParty.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')
      # res = Excon.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')[:body]
      # last_keychain_id = JSON.parse(res)['last_keychain_id'].to_i
      order = StraightServerKit::Order.new(amount: params[:amount_of_btc].to_f, callback_data: cookies[:customer_uid]) # , keychain_id: last_keychain_id + 1
      @order = @client.orders.create(order)
    rescue
      return render :failed, locals: { error_info: "ERROR: failed to connect to straight server. Please try again later." }
    end
    @amount = params[:amount_of_btc].to_f
    return render :success
  end

  def 
  def payment_callback
  end

  def exchange_rate
    return render :failed, locals: { error_info: "ERROR: params error"} if params[:amount].blank? || params[:from_unit].blank? || params[:to_unit].blank?
    amount = ExchangeRate.exchange_amount(cookies[:gateway_uid], params[:from_unit], params[:to_unit], params[:amount])
    return render json: {amount: amount }
  end

  private

  def validate_secret
    unless StraightServerKit.valid_callback?(signature: ENV['HTTP_X_SIGNATURE'], request_uri: (URI(ENV['REQUEST_URI']).request_uri \
              rescue ENV['REQUEST_URI']), secret: ENV['SECRET_KEY_BASE'])
      return render plain: "ERROR: Signature is incorrect." 
    end
  end

  def set_client
    if Rails.env.production?
      @client = StraightServerKit::Client.new(gateway_id: @gateway.id, secret: @gateway.secret, url: ENV['STRAIGHT_SERVER_URL'])
    else
      @client = StraightServerKit::Client.new(gateway_id: 1, secret: ENV['STRAIGHT_SERVER_SECRET'], url: ENV['STRAIGHT_SERVER_URL'])
    end
  end

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
end
