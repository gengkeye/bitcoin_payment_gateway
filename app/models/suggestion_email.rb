class SuggestionEmail < ApplicationRecord
	after_create :create_results, if: ->  { self.suggestion != 'keep' }

	has_many :results, class_name: 'SuggestionEmailResult', dependent: :destroy

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
   def create_results
   	   [15, 30, 60, 120].each do |t|
   			CreateSuggestionEmailResultWorker.perform_in(t.minutes, self.id, t)
   	   end
   end
end