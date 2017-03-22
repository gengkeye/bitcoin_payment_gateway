class PaymentsController < ApplicationController
  # before_action :validate_callback
  # before_action :create_order, only: [:index]

 #  	nonce = (Time.now.to_f * 1e3).to_i
	# x_signature = XSignature::HexSignatureValidator.signature(
	#   secret: 'secret', nonce: nonce, body: '', method: 'post', request_uri: 'http://localhost:9696/gateways/1/orders?amount=1&secret=secret&keychain_id=1'
	# )

 #  	hs = Excon.post('http://localhost:9696/gateways/1/orders?amount=1&secret=secret&keychain_id=1',
 #  		:body => URI.encode_www_form(:language => 'ruby', :class => 'fog'),
 #  		:headers => { "Content-Type" => "application/x-www-form-urlencoded",
 #  					  "X-Signature" => x_signature,
 #  					  'X-Nonce' => nonce,
 #  					  'X-Client' => 1 })
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
    # uncomnent this on development environment.
  	# @amount , @address, @tid = 1, "afjwDAoejrfasejfDEuexworAEQ", 1
    # render :invoice and return
    begin
      res = HTTParty.get('http://localhost:9696/gateways/1/last_keychain_id')
    rescue Exception => e
      return render plain: "DATA ERROR!"
    end
  	if params[:amount].blank? || params[:user_uid].blank?
      request.referer.blank? ? (return render "ERROR") : (return redirect_to request.referer)
    end
  	order = StraightServerKit::Order.new(amount: params[:amount] || 1, callback_data: params[:order_uid] || 1, keychain_id: JSON.parse(res)['last_keychain_id'] + 1)
    @order = @client.orders.create(order)
    @amount = params[:amount].to_f
    @address = @order.address
    render :invoice and return
  end

  # def validate_callback
  # 	if StraightServerKit.valid_callback?(signature: ENV['HTTP_X_SIGNATURE'], request_uri: (URI(ENV['REQUEST_URI']).request_uri rescue ENV['REQUEST_URI']), secret: ENV['SECRET_KEY_BASE'])
  # 	end
  # end
end
