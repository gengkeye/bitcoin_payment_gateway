class Withdrawal < ActiveRecord::Base
	belongs_to :user
	belongs_to :gateway
	belongs_to :auditor, class_name: 'users', foreign_key: :auditor_id

	enum status: {
		aplying: 1,
		approved: 2,
		disapproved: 3,
		transfering: 4,
		transfered: 5
	}

	def to_csv_test(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |order|
	      csv << order.attributes.values_at(*column_names)
	    end
	  end
	end
end