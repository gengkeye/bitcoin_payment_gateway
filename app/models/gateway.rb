class Gateway < ActiveRecord::Base
	include Uid

	belongs_to :user
	has_many :orders
end