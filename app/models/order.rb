class Order < ActiveRecord::Base
	include Uid

	belongs_to :user
	belongs_to :gateway
end