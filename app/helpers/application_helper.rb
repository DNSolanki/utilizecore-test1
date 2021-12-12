module ApplicationHelper
	def date_format(date)
    	return date.present? ? date.strftime('%d/%m/%Y') : ''
    end


    def file_date_format(file)
    	if file.present?
    		source_path = Rails.root.join("public", "orders_exported/#{file}")
    		file_date = File.mtime(source_path)
    		date_format(file_date)
    	end
    end
end
