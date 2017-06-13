class CreateSuggestionEmailResultWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'pay_suggestion_email_results', retry: true, backtrace: true

  def perform(email_id, interval)
  	Rails.logger.debug "CreateSuggestionEmailResultWorker start"
  	@email = SuggestionEmail.find_by(id: email_id)
  	last_price = ExchangeRate.get_last_price

 	if @email.present?
 		@result = @email.results.build(time_interval: interval, fbase: @email.fbase, before_price: @email.last_price, now_price: last_price, gap: last_price - @email.last_price, fbase_source: @email.fbase_source)
 		if (@email.suggestion == 'buy' && @email.last_price * 1.01 < last_price) || (@email.suggestion == 'sell' && @email.last_price / 1.01 > last_price)
 			@result.correct = true
 		else
 			@result.correct = false
 		end
 		@result.save!
 	end
  	Rails.logger.debug "CreateSuggestionEmailResultWorker end"

  end
end
