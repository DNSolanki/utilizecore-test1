require 'fileutils'

namespace :parcel_report do
  # Parcel report generated everyday 12:00 am by using rake task and whenever gem
  desc "Export Parcel report"
  task :export_report => :environment do
    begin
      parcel = ParcelsController.new
      parcel.export_parcel_report
      
    rescue Exception => e
      puts e
    end
  end
end