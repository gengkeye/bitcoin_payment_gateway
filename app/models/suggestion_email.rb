class SuggestionEmail < ApplicationRecord
	after_create :create_results, if: ->  { self.suggestion != 'keep' }

	has_many :results, class_name: 'SuggestionEmailResult', dependent: :destroy

	scope :last_both_sources_mail, -> { where(fbase_source: "both_sources").last(1) }

	enum symbol: {
		ltccny: 0,
		btccny: 1,
		ethcny: 2
	}

	enum suggestion: {
		buy: 0,
		sell: 1,
		keep: 2,
		strong_buy: 3,
		strong_sell: 4
	}

	enum fbase_source: {
		commission_sheet: 0,
		last_orders: 1,
		both_sources: 2
	}

   def create_results
   	   [720, 840, 960, 1080, 1200, 1320, 1440, 1680, 1800, 2160, 2520, 2880, 3360, 3600, 4200].each do |t|
   			CreateSuggestionEmailResultWorker.perform_in(t.minutes, self.id, t)
   	   end
   end
end