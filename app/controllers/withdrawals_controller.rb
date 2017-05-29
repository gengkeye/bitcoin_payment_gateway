class WithdrawalsController < ApplicationController
  before_action :validate_param, if: -> { Rails.env.production? }

  def new
  	@sub_title = 'withdraw'
  	@form_path = "#{request.original_url}/withdrawals"
  	@btn_name = 'withdraw_btn'
  end

  def success
  end

  def enable
  end

  def disable
  end

  def create
  	return render :failed, locals: { error_info:  t("errors.params_error") } if params[:amount_of_btc].blank?
  	@withdrawal =  Withdraw.new(user_id: cookies[:user_id],
                                gateway_id: cookies[:gateway_id],
                                customer_uid: cookies[:customer_uid],
                                amount: params[:amount_of_btc])
  	if @withdrawal.save
  		return redirect_to success_withdrawals_path
  	else
  		return render :failed, locals: { error_info: t("errors.create_error") + ':' + @withdrawal.errors }
  	end
  end
end
