class UpdateSuggestionEmailWorker
  include Sidekiq::Worker

  def perform(email_id, interval)
  	@email = SuggestionEmail.find_by(id: email_id)
  	last_price = ExchangeRate.get_last_price
 	if @email.present?
 		@result = @email.results.new(time_interval: interval)
 		if (@email.suggestion == 'buy' && @email.last_price * 1.01 < last_price) || (@email.suggestion == 'sell' && @email.last_price / 1.01 > last_price)
 			@result.correct = true
 		else
 			@result.correct = false
 		end
 		@result.save!
 	end
  end
end
