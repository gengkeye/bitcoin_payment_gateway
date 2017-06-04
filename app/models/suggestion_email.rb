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
   end
end