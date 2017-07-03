class SendEmailWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'pay_mailers', retry: true, backtrace: true

  def perform
	begin
		params = ExchangeRate.give_secret
		case params[:suggestion]
		when 'buy', 'sell'
	        begin
	            @suggestion_email = SuggestionEmail.create!(params)
	            Rails.logger.debug "id-----------------------------------------------#{@suggestion_email.id}"
			    Rails.logger.debug("You should #{ params[:suggestion] } some ltc now. Time: #{Time.now}")
		        LtcMonitorMailer.suggest_mail(@suggestion_email.id).deliver_later
		    rescue
		    	raise "Create SuggestionEmail failed."
		    end
			sleep 60
		when 'keep'
			Rails.logger.debug "Don't do any thing now. Time: #{Time.now}"
		end
		sleep 30
		
	end while Time.now < Time.new(2018,6,31,18)
  end
end



