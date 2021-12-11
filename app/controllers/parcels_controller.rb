class ParcelsController < ApplicationController
  before_action :authenticate_user!, :except => [:export_parcel_report]
  before_action :set_parcel, only: %i[ show edit update destroy change_status update_status]
  before_action :get_users, :service_type, only: %i[ new edit]
  

  # GET /parcels or /parcels.json
  def index
    # Code Added by Dharmendra Solanki
    # if addmin login then show all the parcel list and 
    # if user login then show only own parcel and own created parcel list.
    if current_user.present? && current_user.is_admin?
      @parcels = Parcel.order(id: :desc).includes(:sender, :receiver, :service_type)
    else
      @parcels = Parcel.where(sender_id: current_user.id).or(Parcel.where(receiver_id: current_user.id)).or(Parcel.where(created_by: current_user.id)).order(id: :desc).includes(:sender, :receiver, :service_type)
    end

    # Download export parcel list
    if (params[:format] == 'xlsx')

      file_name = Time.now.to_i
      xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'parcels/index.xlsx.axlsx', locals: {parcels: @parcels}
      
      File.open("public/orders_exported/parcel_report_#{file_name}.xlsx", 'w') do |file|
        file.write(xlsx)
      end
    
    end
    
  end

  # Show the all export excel file and dowload the files
  def parcel_export_files
    if params[:file_name].present?
      send_file Rails.root.join("public", "orders_exported/#{params[:file_name]}")
    else
      source_path = Rails.root.join("public", "orders_exported")
      #@contains =  Dir.entries(Rails.public_path) - %w[. ..]
      @contains =  Dir.entries(source_path) - %w[. ..]
    end
    
  end

  # GET /parcels/1 or /parcels/1.json
  def show
  end

  # GET /parcels/new
  def new
    @parcel = Parcel.new
    # Code Added by Dharmendra Solanki
  end

  # GET /parcels/1/edit
  def edit
  end

  # POST /parcels or /parcels.json
  def create
    @parcel = Parcel.new(parcel_params)

    respond_to do |format|
      if @parcel.save
        # Added two columns created_by and update_by 
        @parcel.created_by = current_user.id
        @parcel.updated_by = current_user.id
        @parcel.save
        #Create a Parcel history
        create_parcel_history
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html do
          # Get All User
          get_users
          # Get All Service Type
          service_type
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcels/1 or /parcels/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        @parcel.update_attribute(:updated_by, current_user.id)
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1 or /parcels/1.json
  def destroy
    @parcel.destroy
    respond_to do |format|
      format.html { redirect_to parcels_url, notice: 'Parcel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Show the parcel status 
  def change_status
  end


  # Update Parcel status and send the notification both user sender and receiver
  # PATCH/PUT /parcels/update_status/1 or /parcels/update_status/1.json
  def update_status
    respond_to do |format|
      if @parcel.update_attribute(:status, params[:parcel][:status])
        # Create a parcel history
        create_parcel_history
        @parcel.change_status_notification

        format.html { redirect_to parcels_url, notice: 'Parcel status was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # Maintain Parcel History list
  def history
    @parcel_history = ParcelHistory.joins(:parcel).select('parcel_histories.*', 'parcels.parcel_number').where(parcel_id: params[:id]).order(id: :desc)
  end 

  # Parcel report generated everyday 12:00 am by using rake task and whenever gem
  def export_parcel_report
    @parcels = Parcel.order(id: :desc).includes(:sender, :receiver, :service_type).references(:sender, :receiver, :service_type)

    file_name = Time.now.to_i
      xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'parcels/index.xlsx.axlsx', locals: {parcels: @parcels}
      
      File.open("public/orders_exported/parcel_report_#{file_name}.xlsx", 'w') do |file|
        file.write(xlsx)
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      @parcel = Parcel.find(params[:id])
    end

    # create a parcel status history
    def create_parcel_history
      @parcel_hisotry = ParcelHistory.new
      @parcel_hisotry.parcel_id = @parcel.id
      @parcel_hisotry.status = params[:parcel][:status]
      @parcel_hisotry.save
    end
    
    # Added new Method 
    def get_users
      if current_user.present? && current_user.is_admin?
        user_record = User.includes(:address).references(:address)
      else
        user_record = User.where(id: current_user.id).or(User.where(created_by: current_user.id)).includes(:address).references(:address)
      end
      
      @users = user_record.map{|user| [user.name_with_address, user.id]}
    end

    def service_type
      
      @service_types = ServiceType.pluck(:name, :id)

    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      params.require(:parcel).permit(:weight, :status, :service_type_id,
                                     :payment_mode, :sender_id, :receiver_id,
                                     :cost)
    end
end
