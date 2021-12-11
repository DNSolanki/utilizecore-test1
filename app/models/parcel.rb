class Parcel < ApplicationRecord

	STATUS = ['New','Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']

	validates :weight, :status, presence: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	has_many :parcel_histories

	after_create :send_notification

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
