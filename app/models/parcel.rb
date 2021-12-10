class Parcel < ApplicationRecord

	STATUS = ['Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']

	validates :weight, :status, presence: true
	validates :cost, presence:  true, numericality: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	after_create :send_notification

	#Added New method for insert parcel unique number using for SecureRandom.random_number function
	# This function generate three digit and concatenate of parcel id.
    def update_parcel_number!
    	number = SecureRandom.random_number(1000)
    	unique_number = "#{number}#{self.id}"
    	update_column :parcel_number, unique_number
  	end

	private

	def send_notification
		UserMailer.with(parcel: self).status_email.deliver_later
	end



end
