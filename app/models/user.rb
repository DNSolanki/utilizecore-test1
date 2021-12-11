class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	validates :name,:email, presence: true
	validates :email, uniqueness: true

	ROLE = ['User', 'Admin']

	has_one :address, :dependent => :destroy
	has_many :send_parcels, foreign_key: :sender_id, class_name: 'Parcel'
	has_many :received_parcels, foreign_key: :receiver_id, class_name: 'Parcel'

	accepts_nested_attributes_for :address

	# join username, user mobile and user address
	def name_with_address
		# Remove code by Dharmendra Solanki
		username ||= [name, address.address_line_one, address.city, address.state, 

			address.country, address.pincode].join('-')
		return "#{username} (Mob. #{address.mobile_number})"
	end

	def is_admin?
    (role && role == 'Admin')
  end

  #  After login create a new user then send user registration mail 
  def user_registration_notification(password)
		UserMailer.with(user: self, password: password).registration_mail.deliver_later
	end
end
