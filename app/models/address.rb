class Address < ApplicationRecord
	validates :address_line_one, :city, :state, :country, presence: true
	validates_numericality_of :pincode, only_integer: true, allow_blank: true
	validates :mobile_number,presence: true, numericality: true,
                length:  { minimum: 8, maximum: 13 }

	belongs_to :user
end
