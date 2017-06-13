class SuggestionEmailResult < ApplicationRecord
	belongs_to :suggestion_email
	validates_presence_of :time_interval, :before_price, :now_price, :fbase, :gap
	enum unit: {
		minute: 0,
		hour: 1,
		day: 2
	}
	enum fbase_source: {
		commission_sheet: 0,
		last_orders: 1
	}
	class << self
		def success_rate(fbase_source)
			(SuggestionEmailResult.where(correct: true, fbase_source: fbase_source).count.to_f / SuggestionEmailResult.count).to_f.round(4)
		end

		# column in %w(fbase time_interval)
		def get_success_rate_detail(column, fbase_source)
			ActiveRecord::Base.connection.select_all("select result1.#{column}, result1.correct_num, result2.total_nums, (result1.correct_num / result2.total_nums) as success_rate, result1.fbase_source
													  from (select #{column}, count(id) as correct_num, fbase_source 
													  		from suggestion_email_results 
													  		where correct = 1 and fbase_source = #{SuggestionEmailResult.fbase_sources[fbase_source]} 
													  		group by #{column}, fbase_source) as result1
													  left join (select #{column}, count(id) as total_nums
													             from suggestion_email_results 
													             group by #{column}) as result2 on result1.#{column} = result2.#{column}
													  order by success_rate desc")
			
		end
	end
end

