class ApicallsController < ApplicationController

  before_filter :authorize
  before_filter :match_user, :only => [:rtf, :rtf_mock, :show]

# CREATE
  def create
    @left_off = params[:apicall][:left_off]
    # If the user checked the "pick up where I left off" checkbox,
    # find out where they left off in recording their statuses.
    if (@left_off == true || @left_off == "1")
       @since = DateFormatter.set_since(@user.apicalls)
    # Otherwise, use any "since" and "until" dates from the form.
    # Format them using DateFormatter.find_date.
    else  
       @since = DateFormatter.find_date("since", params[:apicall])
       @until = DateFormatter.find_date("until", params[:apicall])
    end
    session[:token] = params[:access_token]
    # Create the apicall with a combination of form data and the
    # the values obtained above. 
    @apicall = Apicall.new(:access_token => session[:token], :user_id => @user.id, :since => @since, 
                           :until => @until, :output_format => params[:apicall][:output_format], :left_off => @left_off)
      # If the Apicall is saved, populate it with statuses by 
      # redirecting to status/create_statuses.  Otherwise,
      # redirect to the main page.
      if @apicall.save
        session[:apicall] = @apicall.id
        flash[:format] = @apicall.output_format
        redirect_to create_statuses_url
      else
      redirect_to root_url
    end
  end

# RTF
  def rtf
    # Generate an RTF document with the user's statuses.
    status_archive = FormatRtf.format(@user, @apicall.statuses)
    File.open('status_archive.rtf', 'w') {|file| file.write(status_archive.to_rtf)}
    # Send the file to the user.
    send_file 'status_archive.rtf', :type => 'text/rtf; charset=utf-8'
  end

# RTF MOCK
  def rtf_mock
    # This is a mock version of the rtf action above.
    # It is used for testing only.
    status_archive = FormatRtf.format(@user, @apicall.statuses)
    File.open('status_archive.txt', 'w') {|file| file.write(status_archive)}
    send_file 'status_archive.txt', :type => 'text/plain; charset=utf-8'
  end

# SHOW
  def show
  end

protected

# MATCH USER
  def match_user
    # Search the current user's Apicalls to find one
    # that matches the id parameter from the URL.
    # If not found, redirect to the main page.
    id = params[:id]
    @apicall = @user.apicalls.find(id)
    rescue
      flash[:notice] = "You can only view your own data!"
      redirect_to root_url
  end
end
