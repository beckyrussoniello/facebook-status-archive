module JsonParser
require 'json/add/rails'

# This module deals with acquiring status data from the 
# Facebook Graph API.  

# The URL for an API call always begins with 
# https://graph.facebook.com/me/statuses -- we will call
# this the BASE_URL.  An access token (unique for every
# session) must be appended.  Additional parameters (such
# as "since" and "until") are optional.

# Once the URL is constructed, we curl that page.  The data
# is received as JSON, which is then parsed and returned 
# to the controller.

# The method 'JsonParser.get_status_attributes' performs more 
# specialized parsing on each individual status -- 
# ultimately returning a hash which is used to initialize
# a Status object.

#GET DATASET FROM FACEBOOK
  def JsonParser.get_dataset(access_token, apicall)
    # Construct the URL to use for the API call.
    url = JsonParser.encode_url(access_token, apicall)
    # Make the API call and parse the received JSON
    dataset = JsonParser.extract_useful_data(url)
    # Return the relevant data
    return dataset
  end

#GET STATUS INFO
  def JsonParser.get_status_info(object, user, apicall, i)
    # Isolate the data for one particular status.
    @data = object[i]
    # Extract the values for each attribute   
    updated_time = @data["updated_time"]
    message = @data["message"]
    # Reformat 'updated_time' to be more readable (using the
    # DateFormatter module)
    @datetime_string = DateFormatter.format_datetime_string(updated_time)
    # Consolidate the attributes into a hash, and return them.
    status_hash = {:user_id => user.id, :apicall_id => apicall.id, 
		   :message => message, :datetime => updated_time, 
                   :datetime_string => @datetime_string}
    return status_hash
  end

#ENCODE URL
  def JsonParser.encode_url(access_token, apicall)
    # First, append the encoded access token to the base URL.
    url = "#{BASE_URL}&access_token=#{URI.encode(access_token)}&limit=#{LIMIT}"
    # If each of the following parameters has been specified, 
    # encode the value and add it on to the URL.
    for i in ["since", "until"]
      if apicall[i.to_sym]  
        url << "&#{i}=#{URI.encode(apicall[i.to_sym].to_s)}"
      end
    end
    return url
  end

#EXTRACT USEFUL DATA
  def JsonParser.extract_useful_data(url)
    # Curl the page specified by the URL.
    page = Curl::Easy.perform(url)
    body = page.body_str
    # Parse the received JSON and return it.
    @object = JSON.parse(body)
    dataset = JsonPath.new("$.data").on(@object).to_a   
    dataset = dataset[0]
    return dataset
  end

end
