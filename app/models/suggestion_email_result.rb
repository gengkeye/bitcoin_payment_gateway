class SuggestionEmailResult < ApplicationRecord
	belongs_to :suggestion_email

	enum unit: {
		minute: 0,
		hour: 1,
		day: 2,
		week: 3,
		year: 4
	}
end