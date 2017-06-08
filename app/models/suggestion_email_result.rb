class SuggestionEmailResult < ApplicationRecord
	belongs_to :suggestion_email
	validates_presence_of :time_interval, :before_price, :now_price, :fbase, :gap
	enum unit: {
		minute: 0,
		hour: 1,
		day: 2
	}

	class << self
		def success_rate
			(SuggestionEmailResult.where(correct: true).count.to_f / SuggestionEmailResult.count).to_f.round(4)
		end

		# column in %w(fbase time_interval)
		def get_success_rate_detail(column)
			ActiveRecord::Base.connection.select_all("select result1.#{column}, result1.correct_num, result2.total_nums, (result1.correct_num / result2.total_nums) as success_rate
													  from (select #{column}, count(id) as correct_num from suggestion_email_results where correct = 1 group by #{column}) as result1
													  join (select #{column}, count(id) as total_nums  from suggestion_email_results group by #{column}) as result2 on result1.#{column} = result2.#{column}
													  order by success_rate desc")
			
		end
	end
end