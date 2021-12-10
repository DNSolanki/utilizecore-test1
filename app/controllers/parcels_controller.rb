class ParcelsController < ApplicationController
  before_action :set_parcel, only: %i[ show edit update destroy ]
  before_action :get_users, :service_type, only: %i[ new edit]
  # GET /parcels or /parcels.json
  def index
    # Code Added by Dharmendra Solanki
    # N+1 queries problem
    @parcels = Parcel.order(id: :desc).includes(:sender, :receiver, :service_type)

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
         @parcel.update_parcel_number!
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html do
          # Code Added by Dharmendra Solanki
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      @parcel = Parcel.find(params[:id])
    end

    # Added new Method 
    def get_users
      user_record = User.includes(:address)
      @users = user_record.map{|user| [user.name_with_address, user.id]}
    end

    def service_type

      # Replaced map method by pluck method
      @service_types = ServiceType.pluck(:name, :id)
    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      params.require(:parcel).permit(:weight, :status, :service_type_id,
                                     :payment_mode, :sender_id, :receiver_id,
                                     :cost)
    end
end
