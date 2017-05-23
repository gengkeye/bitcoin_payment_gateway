class WithdrawalsController < ApplicationController
  before_action :validate_param, if: -> { Rails.env.production? }

  def new
  	@sub_title = 'withdraw'
  	@form_path = "#{request.original_url}/withdrawals"
  	@btn_name = 'withdraw_btn'
  end

  def success
  end

  def create
  	return render :failed, locals: { error_info: "ERROR: lack of params." } if params[:amount_of_btc].blank?

  	@withdrawal =  Withdraw.new(user_id: cookies[:user_id], gateway_id: cookies[:gateway_id], customer_id: cookies[:customer_id], amount: params[:amount_of_btc])
  	if @withdrawal.save
  		return redirect_to success_withdrawals_path
  	else
  		return render :failed, locals: { error_info: "Failed to create.#{@withdrawal.errors}"}
  	end
  end
end
