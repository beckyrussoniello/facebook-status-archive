module ApplicationHelper

	def spinner_tag id
  	#Assuming spinner image is called "spinner.gif"
  	image_tag("ajax-loader.gif", :id => id, :alt => "Loading....", :class => "invisible")
	end
end
