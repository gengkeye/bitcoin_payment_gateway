class PaymentsController < ApplicationController
  before_action :validate_callback, only: [:payment_callback]

  def initialize
    @client = StraightServerKit::Client.new(gateway_id: 1, secret: ENV['STRAIGHT_SERVER_SECRET'], url: ENV['STRAIGHT_SERVER_URL'])
    super
  end

  def index
  end

  def invoice
  end

  def update
  	begin
	  	@client.orders.cancel(id: params[:id])
	  	return redirect_to :index
	rescue
		return render :failed
	end
  end

  def create
    begin
      # res = HTTParty.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')
      res = Excon.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')[:body]
      last_keychain_id = JSON.parse(res)['last_keychain_id'].to_i
    rescue
      return render plain: "ERROR: can't connect to straight server"
    end
  	if params[:amount].blank? || params[:user_uid].blank?
      request.referer.blank? ? (return render plain: "ERROR: lack of params.") : (return redirect_to request.referer)
    end

  	order = StraightServerKit::Order.new(amount: params[:amount] || 1, callback_data: params[:order_uid] || 1, keychain_id: last_keychain_id + 1)
    @order = @client.orders.create(order)
    @amount = params[:amount].to_f
    render :invoice and return
  end

  def payment_callback
  end

  private

  def validate_callback
  	if StraightServerKit.valid_callback?(signature: ENV['HTTP_X_SIGNATURE'], request_uri: (URI(ENV['REQUEST_URI']).request_uri rescue ENV['REQUEST_URI']), secret: ENV['SECRET_KEY_BASE'])
  	end
  end
end
