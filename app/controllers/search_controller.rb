class SearchController < ApplicationController
  def index
    if params[:search].present?
      @parcels = Parcel.where(parcel_number: params[:search])
    else
      @parcels = []
    end
  end
end
