class Parcel < ApplicationRecord

	STATUS = ['New','Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']

	validates :weight, :status, presence: true
	validates :cost, presence:  true, numericality: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	has_many :parcel_histories

	after_create :send_notification

	#Added New method for insert parcel unique number using for SecureRandom.random_number function
	# This function generate three digit and concatenate of parcel id.
    def update_parcel_number!
    	number = SecureRandom.random_number(1000)
    	unique_number = "#{number}#{self.id}"
    	update_column :parcel_number, unique_number
  	end
	
	# Send change status notification for both user
	def change_status_notification
		UserMailer.with(parcel: self).change_status_email.deliver_later
	end

	private
		# Send notification after create the parcel for both user
		def send_notification
			UserMailer.with(parcel: self).status_email.deliver_later
		end





end
