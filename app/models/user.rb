class User < ActiveRecord::Base
	include Uid
	has_many :gateways
end