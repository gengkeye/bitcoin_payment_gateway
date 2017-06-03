class ExchangeRate < ActiveRecord::Base
	PROVIDERS = { 
		'Huobi' => "http://api.huobi.com/staticmarket/ticker_btc_json.js",
		'Okcoin' => "https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny",
		'Btcchina' => "https://data.btcchina.com/data/ticker?market=btccny",
		# 'blockchain' => "https://blockchain.info/ticker"
	}
	DEPTH_API_URL = "http://api.huobi.com/staticmarket/depth_ltc_150.js"
	TICKER_API_URL = "http://api.huobi.com/staticmarket/ticker_ltc_json.js"

	class << self
		def exchange_amount(gateway_id, from_unit, to_unit, amount)
			if from_unit == 'btc'
			    (amount.to_f * get_last_rate(gateway_id, to_unit.upcase).to_f).round 2
			else
				(amount.to_f / get_last_rate(gateway_id, from_unit.upcase).to_f).round 4
			end
		end

		def get_last_rate(gateway_id, unit)
			@gateway = Gateway.find_by(id: gateway_id)
			raise "Gateway is not found" if @gateway.nil?
			r = {}
			@gateway.exchange_rate_adapter_names.split(',').each do |i|
				begin
			      r = HTTParty.get(PROVIDERS[i])
				rescue Exception => e
				  next
				end
		    end
		    if r.present?
		    	# blockchain r[unit].present? ? r["CNY"]["last"] : (raise "Your currency #{unit} is not supported.")
		    	return r["ticker"]["last"] || JSON.parse(r)["ticker"]["last"]
		    else
				raise t("errors.exchange_error")
			end
		end

		def forecast_ltc_price(start_price = 0, end_price = 10000)
			r = get_depth_r
			return (total(r, 'price', start_price, end_price)/total(r, 'amount', start_price, end_price)).round(2)
		end

		def total(r, price_or_amount, start_price, end_price)
			eval("get_total_#{price_or_amount}(#{r}, 'bids', start_price, end_price) + get_total_#{price_or_amount}(#{r}, 'asks', start_price, end_price)")
		end

		def get_total_price(r, flag, start_price, end_price)
			r[flag].inject(0){|sum, i| (i[1] < end_price && i[1] > start_price ) ? sum += i.reduce(:*) : sum += 0  } # (i[1] < 500 && i[1] > 10) ? sum += i.reduce(:*) : sum+=0 
		end

		def get_total_amount(r, flag, start_price, end_price)
			r[flag].inject(0){|sum, i| (i[1] < end_price && i[1] > start_price) ? sum += i[1] : sum += 0  } # (i[1] < 500 && i[1] > 10) ? sum += i[1] : sum+=0 
		end

		def get_last_price
			r = get_ticker_r
			return r["ticker"]["last"]
		end

		def get_depth_r
			begin
				return JSON.parse HTTParty.get(DEPTH_API_URL)
			rescue
				raise "ERROR"
			end
		end

		def get_ticker_r
			begin
				return JSON.parse HTTParty.get(TICKER_API_URL)
			rescue
				raise "ERROR"
			end
		end

		def get_difference
			get_last_price - forecast_ltc_price
		end

		def buy_or_sell
			fprice1000 = forecast_ltc_price(0, 1000)
			fprice10000 = forecast_ltc_price(1000, 20000)
			lprice = get_last_price
			r = { 
				last_price: lprice,
				forecast_price1000: fprice1000,
				forecast_price10000: fprice10000,
			 }
			if (fprice1000 >  lprice * 1.01) || (fprice10000 <  lprice / 1.01)
				return r.merge({ suggestion: "You should buy some ltc now. Time: #{Time.now}", flag: 0 })
			elsif (fprice1000 < lprice / 1.01) || (fprice10000 >  lprice * 1.01)
				return r.merge({ suggestion: "You should sell some ltc now. Time: #{Time.now}", flag: 1 })
			else
				return r.merge({ suggestion: "You should do nothing now. Time: #{Time.now}", flag: 2 })
			end
		end
	end
end