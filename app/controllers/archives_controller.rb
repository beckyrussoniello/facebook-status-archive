class ArchivesController < ApplicationController
  def create
		format = params[:archive][:output_format_id] #|| 1
		start_date, end_date = Archive.get_dates(params)
		@archive = Archive.create!(user_id: session[:user_id], start_date: start_date, 
															end_date: end_date, output_format_id: format)
		@archive.create_statuses!
		redirect_to @archive
  end

  def show
		@archive = Archive.find(params[:id])
		@statuses = @user.statuses.where("timestamp > ? AND timestamp < ?", @archive.start_date, @archive.end_date)
									.order('timestamp DESC')
		if @archive.output_format_id == 2
  		File.open("status_archive_for_#{@user.username}.rtf", "w") do |file|
				file.write(FormatRtf.format(@user, @statuses).to_rtf)
			end
    	send_file Rails.root.join("status_archive_for_#{@user.username}.rtf"), 
							:type => 'text/rtf; charset=utf-8',
							:filename => 'status_archive.rtf',
							:x_sendfile => true
		else
			render do |format|
				format.js {}
				format.html {}
			end
		end
  end
end
