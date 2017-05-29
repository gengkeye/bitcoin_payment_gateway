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
    @order = Order.find_by(tid: params[:id])
  	begin
	  	@order.update status: 'canceled'
	  	return redirect_to :index
  	rescue
  		return render :failed, locals: { error_info: t("errors.update_error") }
  	end
  end

  def create
    if params[:amount_of_btc].blank? || params[:amount_of_cny].blank?
      return render :failed, locals: { error_info: t("errors.params_error") }
    end
    begin
      # res = HTTParty.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')
      # res = Excon.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')[:body]
      # last_keychain_id = JSON.parse(res)['last_keychain_id'].to_i
      order = StraightServerKit::Order.new( amount: params[:amount_of_btc].to_f,
                                            callback_data: {customer_uid: cookies[:customer_uid]},
                                            user_id: cookies[:user_id],
                                            gateway_id: cookies[:gateway_id],
                                            customer_uid: cookies[:customer_uid])
      @order = @client.orders.create(order)
    rescue
      return render :failed, locals: { error_info: t("errors.connect_error") }
    end
    @amount = params[:amount_of_btc].to_f
    return render :success
  end

  def payment_callback
  end

  def exchange_rate
    return render :failed, locals: { error_info: t("errors.params_error") } if params[:amount].blank? || params[:from_unit].blank? || params[:to_unit].blank?
    amount = ExchangeRate.exchange_amount(cookies[:gateway_id], params[:from_unit], params[:to_unit], params[:amount])
    return render json: {amount: amount }
  end

  private

  def set_client
    if Rails.env.production?
      @client = StraightServerKit::Client.new(gateway_id: @gateway.id, secret: @gateway.secret, url: ENV['STRAIGHT_SERVER_URL'])
    else
      @client = StraightServerKit::Client.new(gateway_id: 1, secret: ENV['STRAIGHT_SERVER_SECRET'], url: ENV['STRAIGHT_SERVER_URL'])
    end
  end
end
