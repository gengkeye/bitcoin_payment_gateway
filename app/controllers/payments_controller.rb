class PaymentsController < ApplicationController
  before_action :validate_callback, only: [:payment_callback]

  def initialize
    @client = StraightServerKit::Client.new(gateway_id: 1, secret: ENV['STRAIGHT_SERVER_SECRET'], url: ENV['STRAIGHT_SERVER_URL'])
    super
  end

  def index
    if params[:uid].blank?
      request.referer.blank? ? (return render plain: "ERROR: lack of params.") : (return redirect_to request.referer)
    end
  end

  def update
  	begin
	  	@client.orders.cancel(id: params[:id])
	  	return redirect_to :index, locals: { uid: params[:uid] }
  	rescue
  		return render :failed, locals: { error_info: "ERROR: This order cannot be canceled now. Please try again later." }
  	end
  end

  def create
    begin
      # res = HTTParty.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')
      res = Excon.get(ENV['STRAIGHT_SERVER_URL'] + 'gateways/1/last_keychain_id')[:body]
      last_keychain_id = JSON.parse(res)['last_keychain_id'].to_i
      if params[:amount].blank? || params[:uid].blank?
        return render :failed, locals: { error_info: "ERROR: lack of params." }
      end

      order = StraightServerKit::Order.new(amount: params[:amount], callback_data: params[:uid]) # , keychain_id: last_keychain_id + 1
      @order = @client.orders.create(order)
      @amount = params[:amount].to_f
      return render :success
    rescue
      return render :failed, locals: { error_info: "ERROR: failed to connect to straight server. Please try again later." }
    end
  end

  def payment_callback
  end

  private

  def validate_callback
  	if StraightServerKit.valid_callback?(signature: ENV['HTTP_X_SIGNATURE'], request_uri: (URI(ENV['REQUEST_URI']).request_uri rescue ENV['REQUEST_URI']), secret: ENV['SECRET_KEY_BASE'])
  	end
  end
end
