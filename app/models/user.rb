class User < ApplicationRecord
	has_many :gateways
	has_many :orders
end