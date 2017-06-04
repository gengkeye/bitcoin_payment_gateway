class Gateway < ApplicationRecord
	include Uid

	belongs_to :user
	has_many :orders
end