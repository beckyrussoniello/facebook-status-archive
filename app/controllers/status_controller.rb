class StatusController < ApplicationController

  before_filter :authorize

# CREATE STATUSES
  def create_statuses
    @apicall = Apicall.find(session[:apicall])
    # Get the status data from Facebook.
    if dataset = JsonParser.get_dataset(session[:token], @apicall) 
      # If successful, create a Status object in the app for
      # every status in the dataset.
      @lim = dataset.size - 1 
        for i in 0..@lim do
          Status.create!(attributes = JsonParser.get_status_info(dataset, @user, @apicall, i))         
        end
        # The contents of flash[:format] tell the app whether
        # to proceed with HTML or RTF.  Redirect accordingly.
        if flash[:format] == "HTML"
          redirect_to show_html_url(:id => @apicall.id)
        elsif flash[:format] == "Rich Text"
          redirect_to rtf_url(:id => @apicall.id)
        end
    else
      # If unsuccessful in obtaining the dataset, inform the
      # user that their access token has expired.  Destroy
      # the Apicall and redirect back to the main page.
      flash[:notice] = "Your access token seems to have expired.  Try logging out and logging back in again; then everything should work."
      session[:apicall] = nil and @apicall.destroy
      redirect_to root_url
    end
  end
end
