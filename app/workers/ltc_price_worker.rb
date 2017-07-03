class LtcPriceWorker
	include Sidekiq::Worker
    sidekiq_options queue: 'pay_mailers', retry: true, backtrace: true

	def perform
		begin
		   Rails.logger.debug "LtcPriceWorker start: #{Time.now}"
		   [[0, 100], [0, 1000], [0, 20000], [100, 1000], [1000, 20000], [10000, 20000], [1000, 5000], [5000, 10000]].map do |a|
		   	    params = ExchangeRate.buy_or_sell(a[0], a[1], 'commission_sheet')
		   	    begin
		   	    	SuggestionEmail.create!(params) if params[:suggestion].to_s != 'keep'
		   	    rescue
		   	    	raise 'Create SuggestionEmail failed.'
		   	    end
		   end
		   Rails.logger.debug "LtcPriceWorker end: #{Time.now}"
		   Rails.logger.debug "I'm tired. I need to sleep for 900 seconds"
		   sleep 900
		end while Time.now < Time.new(2017,8,31,18)
	end
end