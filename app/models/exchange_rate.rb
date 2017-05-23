class ExchangeRate < ActiveRecord::Base
	PROVIDERS = { 
		'huobi' => "http://api.huobi.com/staticmarket/ticker_btc_json.js",
		'okcoin' => "https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny",
		'btcchina' => "https://data.btcchina.com/data/ticker?market=btccny",
		# 'blockchain' => "https://blockchain.info/ticker"
	}
	class << self
		def exchange_amount(gateway_uid, from_unit, to_unit, amount)
			if from_unit == 'btc'
			    (amount.to_f * get_last_rate(gateway_uid, to_unit.upcase).to_f).round 2
			else
				(amount.to_f / get_last_rate(gateway_uid, from_unit.upcase).to_f).round 4
			end
		end

		def get_last_rate(gateway_uid, unit)
			@gateway = Gateway.find_by(uid: gateway_uid)
			raise "Gateway is not found" if @gateway.nil?
			@gateway.exchange_rate_adapter_name.split(',').each do |i|
				begin
			      r = HTTParty.get(PROVIDERS[i])
				rescue Exception => e
				  next
				end
		    end
		    if r.present?
		    	# blockchain r[unit].present? ? r["CNY"]["last"] : (raise "Your currency #{unit} is not supported.")
		    	return r["ticker"]["buy"] || JSON.parse(r)["ticker"]["last"]
		    else
				raise "Can't get exchange rate tmp."
			end
		end
	end
end