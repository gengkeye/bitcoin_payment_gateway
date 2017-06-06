class SuggestionEmailResult < ApplicationRecord
	belongs_to :suggestion_email
	validates_presence_of :time_interval, :before_price, :now_price, :fbase, :gap
	enum unit: {
		minute: 0,
		hour: 1,
		day: 2
	}
end