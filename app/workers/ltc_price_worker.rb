class LtcPriceWorker
	include Sidekiq::Worker

	def perform
		begin
			r = ExchangeRate.buy_or_sell
			case r[:flag]
			when 0
			    Rails.logger.debug "You should buy some ltc now. Time: #{Time.now}"
	            LtcMonitorMailer.suggest_mail(r).deliver_later
				sleep 60
			when 1
				Rails.logger.debug "You should sell some ltc now. Time: #{Time.now}"
	            LtcMonitorMailer.suggest_mail(r).deliver_later
				sleep 60
			when 2
				Rails.logger.debug "Don't do any thing now. Time: #{Time.now}"
			end
			sleep 30
			
		end while Time.now < Time.new(2018,6,31,18)
	end
end