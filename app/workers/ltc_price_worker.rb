class LtcPriceWorker
	include Sidekiq::Worker
    sidekiq_options queue: 'pay_mailers', retry: true, backtrace: true

	def perform
		begin
		   Rails.logger.debug "Start to create a record to SuggestionEmail now."
		   [[0, 100], [0, 1000], [0, 20000], [100, 1000], [1000, 20000]].map do |a|
		   	    params = ExchangeRate.buy_or_sell(a[0], a[1])
		   		SuggestionEmail.create!(params)
		   end
		   Rails.logger.debug "Create successfully. Time: #{Time.now}. Total count: #{SuggestionEmail.count}"
		   Rails.logger.debug "I'm tired. I need to sleep for 120 seconds"
		   sleep 300
		end while Time.now < Time.new(2017,8,31,18)

		# begin
		# 	params = ExchangeRate.buy_or_sell
		# 	case params[:suggestion]
		# 	when 0, 1
	 #            @suggestion_email = SuggestionEmail.create!(params)
		# 	    Rails.logger.debug("You should " + SuggestionEmail.suggestions.key(params[:suggestion]) + "some ltc now. Time: #{Time.now}")
	 #            LtcMonitorMailer.suggest_mail(@suggestion_email.id).deliver_later
		# 		sleep 90
		# 	when 2
		# 		Rails.logger.debug "Don't do any thing now. Time: #{Time.now}"
		# 	end
		# 	sleep 30
			
		# end while Time.now < Time.new(2018,6,31,18)
	end
end