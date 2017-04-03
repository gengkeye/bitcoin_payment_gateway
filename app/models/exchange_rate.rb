class ExchangeRate < ActiveRecord::Base
	class << self
		def exchange_amount(from_unit, to_unit, amount)
			if from_unit == 'btc'
			    (amount.to_f * get_last_rate(to_unit.upcase).to_f).round 2
			else
				(amount.to_f / get_last_rate(from_unit.upcase).to_f).round 4
			end
		end

		def get_last_rate(unit)
			# blockchain API
			begin
				hs = HTTParty.get("https://blockchain.info/ticker")
			rescue
				raise "Can't get exchange rate from blockchain."
			end
		    hs[unit].present? ? hs["CNY"]["last"] : (raise "Your currency #{unit} is not supported.")
		end
	end
end