class SuggestionEmail < ApplicationRecord
	after_create :update_nums, if: ->  { self.suggestion != 'keep' }

	has_many :results, class_name: 'SuggestionEmailResult'

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
   	   %w(15 30 60 240 1440).each do |t|
   			UpdateSuggestionEmailWorker.perform_in(t.minutes, self.id, t)
   	   end
   end
end