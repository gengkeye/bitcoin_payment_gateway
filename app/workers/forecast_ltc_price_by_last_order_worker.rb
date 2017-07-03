class ForecastLtcPriceByLastOrderWorker
  include Sidekiq::Worker
   sidekiq_options queue: 'pay_flpblow', retry: true, backtrace: true

  def perform
    begin
       Rails.logger.debug "ForecastLtcPriceByLastOrderWorker start: #{Time.now}"
       [[1, 50], [51, 100], [101, 500], [501, 1000],[1001, 10000]].map do |a|
          params = ExchangeRate.buy_or_sell(a[0], a[1], 'last_orders')
       		SuggestionEmail.create!(params) if params[:suggestion].to_s != 'keep'
       end
       Rails.logger.debug "ForecastLtcPriceByLastOrderWorker end: #{Time.now}"
       Rails.logger.debug "I'm tired. I need to sleep for 120 seconds"
       sleep 900
    end while Time.now < Time.new(2017,8,31,18)
  end
end
