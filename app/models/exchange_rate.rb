class ExchangeRate < ApplicationRecord
	PROVIDERS = { 
		'Huobi' => "http://api.huobi.com/staticmarket/ticker_btc_json.js",
		'Okcoin' => "https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny",
		'Btcchina' => "https://data.btcchina.com/data/ticker?market=btccny",
		# 'blockchain' => "https://blockchain.info/ticker"
	}

	# depth api
	DEPTH_LTC = "http://api.huobi.com/staticmarket/depth_ltc_150.js"

	# ticker
	TICKER_LTC = "http://api.huobi.com/staticmarket/ticker_ltc_json.js"

	# detail apis
	DETAIL_LTC = "http://api.huobi.com/staticmarket/detail_ltc_json.js"


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

		# forecast by commission_sheet
		def forecast_ltc_price(start_amount = 0, end_amount = 10000)
			r = get_depth_r
			sum, sum_amount = 0, 0

			(r["bids"] + r["asks"]).each do |i|
				if i[1] >= start_amount && i[1] <= end_amount
					sum += i[0] * i[1]
					sum_amount += i[1]
				else
					sum += 0
					sum_amount += 0
				end
			end
			ticker = get_ticker_r
			fprice = sum_amount == 0 ? 0 : (sum / sum_amount).to_f.round(2)
		    if fprice == 0
		 		suggestion = 'keep'
		 	elsif fprice > ticker["ticker"]["last"].round(2)
		 		suggestion = 'buy'
		 	else
		 		suggestion = 'sell'
		 	end
			return { suggestion: suggestion, fprice: fprice}
		end

		# forecast by last_orders
		def give_suggestion_by_detail(start_amount = 1, end_amount = 10000)
			sum_value_of_buy, sum_amount_of_buy, sum_value_of_sell, sum_amount_of_sell = 0, 0, 0, 0
			get_trades.each do |h|
				if h["amount"] >= start_amount && h["amount"] <= end_amount
					if h["direction"] == "buy"
						sum_value_of_buy += h["amount"].to_f * h["price"].to_f
						sum_amount_of_buy += h["amount"].to_f
					elsif h["direction"] == "sell"
						sum_value_of_sell += h["amount"].to_f * h["price"].to_f
						sum_amount_of_sell += h["amount"].to_f
					end
				end
			end
			total_value_diff = (sum_value_of_buy - sum_value_of_sell).round(2)
			amount_diff = (sum_amount_of_buy - sum_amount_of_sell).round(2)
			suggestion = if amount_diff > 0
							'buy'
						 elsif amount_diff == 0
							'keep'
						 else
						 	'sell'
						 end
  			r = { amount_sell: sum_amount_of_sell,
  				  amount_buy: sum_amount_of_buy,
  				  amount_diff: amount_diff.abs,
  				  total_value_diff: total_value_diff.abs,
  				  diff_base: start_amount + end_amount, 
  				  suggestion: suggestion,}
  		    return r

		end

		def get_last_price
			r = get_ticker_r
			return r["ticker"]["last"].to_f
		end

		def get_trades
			r = get_detail_r
			return r["trades"]
		end

		def get_depth_r
			begin
				return JSON.parse HTTParty.get(DEPTH_LTC)
			rescue
				retry
			end
		end

		def get_ticker_r
			begin
				return JSON.parse HTTParty.get(TICKER_LTC)
			rescue
				retry
			end
		end

		def get_detail_r
			begin
				return JSON.parse HTTParty.get(DETAIL_LTC)
			rescue
				retry
			end
		end

		def get_difference
			get_last_price - forecast_ltc_price[:fprice]
		end

		def buy_or_sell(start_amount = 1, end_amount = 10000, fbase_source)
			 ticker = get_ticker_r
			 if fbase_source == 'commission_sheet'
			 	commission_sheet_params = forecast_ltc_price(start_amount, end_amount)
			 	fprice = commission_sheet_params[:fprice]
	            suggestion = commission_sheet_params[:suggestion]
			 elsif fbase_source == 'last_orders'
			    last_orders_params = give_suggestion_by_detail(start_amount, end_amount)
			 	fprice = nil # last_orders don't give fprice
			 	suggestion = last_orders_params.delete(:suggestion)
			 	DirectionDataDiff.create!(last_orders_params)
			 end

			 r = { 
				last_price: ticker["ticker"]["last"].round(2),
				high_price: ticker["ticker"]["high"],
				low_price: ticker["ticker"]["low"],
				open_price: ticker["ticker"]["open"],
				buy_price: ticker["ticker"]["buy"],
				sell_price: ticker["ticker"]["sell"],
				symbol: 'ltccny',
				fbase_source: fbase_source,
				fbase: start_amount + end_amount,
				fprice: fprice,
				suggestion: suggestion,
			 }
			 return r
		end

		def give_secret
			commission_sheet_params = buy_or_sell(10000, 20000, 'commission_sheet')
			last_orders_params = buy_or_sell(1000, 10000, 'last_orders')
			suggestion = if  commission_sheet_params[:suggestion] == last_orders_params[:suggestion]
							commission_sheet_params[:suggestion]
						 else
							'keep'
						 end

			return commission_sheet_params.merge({ fbase: commission_sheet_params[:fbase] + last_orders_params[:fbase],
												   fbase_source: 'both_sources',
												   suggestion: suggestion})
		end
	end
end