class LtcPriceWorker
	include Sidekiq::Worker

	def perform
		begin
			params = ExchangeRate.buy_or_sell
	        @suggestion_email = SuggestionEmail.create!(params)
			case params[:suggestion]
			when 0, 1
			    Rails.logger.debug("You should" + SuggestionEmail.suggestions.key(params[:suggestion]) + "some ltc now. Time: #{Time.now}")
	            LtcMonitorMailer.suggest_mail(@suggestion_email.id).deliver_later
				sleep 120
			when 2
				Rails.logger.debug "Don't do any thing now. Time: #{Time.now}"
			end
			sleep 30
			
		end while Time.now < Time.new(2018,6,31,18)
	end
end