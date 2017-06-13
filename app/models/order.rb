class Order < ApplicationRecord
	include Tid
	
	belongs_to :user
	belongs_to :gateway
end