class User < ApplicationRecord
	include Uid
	has_many :gateways
	has_many :orders
end