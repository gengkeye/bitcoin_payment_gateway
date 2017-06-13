class DirectionDataDiff < ApplicationRecord

	class << self
		# 
		def get_average_amount_sell
			DirectionDataDiff.find_by_sql("select diff_base, avg(amount_sell) as avg_amount from direction_data_diffs group by diff_base").map{|r| [r.diff_base, r.avg_amount.round(2)]}
		end

		def get_average_amount_buy
			DirectionDataDiff.average(:amount_buy).to_f.round 2
			DirectionDataDiff.find_by_sql("select diff_base, avg(amount_buy) as avg_amount from direction_data_diffs group by diff_base").map{|r| [r.diff_base, r.avg_amount.round(2)]}

		end

		def get_average_amount_diff
			DirectionDataDiff.average(:amount_diff).to_f.round 2
			DirectionDataDiff.find_by_sql("select diff_base, avg(amount_diff) as avg_amount from direction_data_diffs group by diff_base").map{|r| [r.diff_base, r.avg_amount.round(2)]}

		end

		def get_average_value_diff
			DirectionDataDiff.average(:total_value_diff).to_f.round 2
			DirectionDataDiff.find_by_sql("select diff_base, avg(total_value_diff) as avg_amount from direction_data_diffs group by diff_base").map{|r| [r.diff_base, r.avg_amount.round(2)]}
			
		end

		def get_median_amount_diff
			DirectionDataDiff.order(:amount_diff).limit(1).offset(DirectionDataDiff.count/2).first.amount_diff
		end

		def get_median_value_diff
			DirectionDataDiff.order(:total_value_diff).limit(1).offset(DirectionDataDiff.count/2).first.total_value_diff
		end

		def get_median_amount_sell
			DirectionDataDiff.order(:amount_sell).limit(1).offset(DirectionDataDiff.count/2).first.amount_sell
		end

		def get_median_amount_buy
			DirectionDataDiff.order(:amount_buy).limit(1).offset(DirectionDataDiff.count/2).first.amount_buy
		end
	end
end