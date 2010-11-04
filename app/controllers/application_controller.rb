# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  require 'uri'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'aa9701db9667f72569c449092cfe341a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

include Facebooker2::Rails::Controller

protected

  def authorize
    unless User.find(session[:user_id])
      flash[:notice] = "You must log in before you can view your statuses."
      redirect_to root_url
    end
    @user = User.find(session[:user_id])
  end

end
