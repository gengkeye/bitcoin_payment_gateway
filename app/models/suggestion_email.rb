class SuggestionEmail < ApplicationRecord
	after_create :update_nums
	enum symbol: {
		ltccny: 0,
		btccny: 1,
		ethcny: 2
	}

	enum suggestion: {
		buy: 0,
		sell: 1,
		keep: 2
	}
   def update_nums
   		@last2_email = SuggestionEmail.find_by(id: self.id - 2)
	 	if @last_email = SuggestionEmail.find_by(id: self.id - 1)
	 		if (@last_email.suggestion == 'buy' && self.last_price > @last_email.last_price * 1.01) \
	 			|| (@last_email.suggestion == 'sell' && self.last_price < @last_email.last_price / 1.01 )
	 			@last_email.update(correct: true, correct_num: @last2_email&.correct_num.to_i + 1)
	 		else
	 			@last_email.update(correct: false, incorrect_num: @last2_email&.incorrect_num.to_i + 1)
	 		end
	 	end
   end
end