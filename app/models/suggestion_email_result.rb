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
		last_orders: 1,
		both_sources: 2
	}
	class << self
		# column: in %w(fbase time_interval)  
		# fbase: trade volume
		# time_interval: judge the decision after how many minutes.
		# fbase_source: in %w(last_orders commission_sheet)

		def success_rate(fbase_source, time = 'Wed, 21 Jun 2017 01:40:05 UTC +00:00')
			results = SuggestionEmailResult.where("fbase_source = ? && created_at > ?", fbase_source, time)
			return (results.where(correct: true).count.to_f/results.count).round(2)
		end

		def get_success_rate_detail(column, fbase_source)
			ActiveRecord::Base.connection.select_all("select result1.#{column}, result1.correct_num, result2.total_nums, (result1.correct_num / result2.total_nums) as success_rate, result1.fbase_source
													  from (select #{column}, count(id) as correct_num, fbase_source 
													  		from suggestion_email_results 
													  		where correct = 1 and fbase_source = #{SuggestionEmailResult.fbase_sources[fbase_source]} 
													  		group by #{column}, fbase_source) as result1
													  left join (select #{column}, count(id) as total_nums, fbase_source 
													             from suggestion_email_results 
													             group by #{column}, fbase_source) as result2 on result1.#{column} = result2.#{column} and result1.fbase_source = result2.fbase_source
													  order by success_rate desc")
			
		end

		def get_success_rate(fbase_source)
			ActiveRecord::Base.connection.select_all("select result1.fbase, result1.time_interval, result1.fbase_source, result1.correct_num, result2.total_nums, (result1.correct_num / result2.total_nums) as success_rate
													  from (select fbase, time_interval, fbase_source, count(id) as correct_num
													  		from suggestion_email_results 
													  		where correct = 1 and fbase_source = #{SuggestionEmailResult.fbase_sources[fbase_source]} 
													  		group by fbase, time_interval, fbase_source) as result1
													  left join (select fbase, time_interval, fbase_source, count(id) as total_nums
													             from suggestion_email_results
													             where fbase_source = #{SuggestionEmailResult.fbase_sources[fbase_source]}
													             group by fbase, time_interval, fbase_source) as result2 on result1.fbase = result2.fbase and result1.time_interval = result2.time_interval and result1.fbase_source = result2.fbase_source
													  order by success_rate desc")
			
		end

		def report
			Rails.logger.debug "====================start report===================="
			%w(last_orders commission_sheet).each do |fbase_source|
			    Rails.logger.debug "====================success_rate(#{fbase_source})===================="
				p success_rate(fbase_source)
				%w(fbase time_interval).each do |column|
			        Rails.logger.debug "====================get_success_rate_detail(#{column}, #{fbase_source})===================="
					p get_success_rate_detail(column, fbase_source)
				end
			    Rails.logger.debug "====================get_success_rate(#{fbase_source})===================="
				p get_success_rate(fbase_source)
			end
			Rails.logger.debug "====================end report===================="

		end
	end
end

