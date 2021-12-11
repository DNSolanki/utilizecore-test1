class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
    before_action :authenticate_user!
     # before_action :configure_permitted_parameters, if: :devise_controller?

    protected

      def after_sign_in_path_for(users)
          parcels_path
      end

      def after_sign_out_path_for(users)
          user_session_path
      end
        # def configure_permitted_parameters
        #      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}

        #      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
        # end

    private


      def authorize_user! 
        unless current_user && current_user.is_admin?
          flash[:notice] = "You are not authorize to access this page."
          redirect_to root_url
        end 
      end

     
end
