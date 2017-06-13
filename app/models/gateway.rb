class Gateway < ApplicationRecord
	include HashedId
	
	belongs_to :user
	has_many :orders
end