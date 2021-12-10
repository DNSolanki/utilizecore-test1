class User < ApplicationRecord
	validates :name, :email, presence: true
	validates :email, uniqueness: true

	has_one :address, :dependent => :destroy
	has_many :send_parcels, foreign_key: :sender_id, class_name: 'Parcel'
	has_many :received_parcels, foreign_key: :receiver_id, class_name: 'Parcel'

	accepts_nested_attributes_for :address


	def name_with_address
		# Remove code by Dharmendra Solanki
		username ||= [name, address.address_line_one, address.city, address.state, 
			address.country, address.pincode].join('-')
		return "#{username} (Mob. #{address.mobile_number})"
	end
end
