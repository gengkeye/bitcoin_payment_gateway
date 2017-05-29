class User < ActiveRecord::Base
	include Uid
	has_many :gateways
	has_many :orders
end