class Order < ApplicationRecord
	include Uid

	belongs_to :user
	belongs_to :gateway
end