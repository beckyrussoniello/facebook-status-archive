module DateFormatter

  # REGEXES
  RYEAR = /(20\d{2})/
  RMONTH_NUMBER = /-(\d{2})-/
  RDATE_A = /-(\d{2})$/  
  RDATE_S = /-(\d{2})T/
  RHOUR = /T(\d{2}):/
  RMINUTE = /:(\d{2})/

  # FIND DATE
  # Takes the "since" or "until" date values entered on the apicall form and 
  # transforms them into the proper parameter format for the Facebook API.
    def DateFormatter.find_date(field, params_apicall)
      # Extract the values for the year, month_number, and day.  (The form stores
      # them in locations such as 'params[:apicall][:since(1i)]')
      year = params_apicall[(field + "(1i)").to_sym]
      month_number = params_apicall[(field + "(2i)").to_sym] 
      day = params_apicall[(field + "(3i)").to_sym]
      # Find the month name, based on the month number.
      month = DateFormatter.find_month(month_number)

      # Construct a string with the provided values.  The string's structure varies
      # according to which fields the user has filled in or left blank.
      @date = case
        when (day && month && year)			then (day + " " + month + " " + year)
        when (month && year) 				then (month + " " + year)
        when (day && month) 				then (day + " " + month + " " + THIS_YEAR)
        when (((day && year)||year) && year==THIS_YEAR) then (FIRST_MONTH + " " + year)
        when (month) 					then (month + " " + THIS_YEAR)
	else					    	     @date = nil
      end
      return @date
    end

  # SET 'since'
  # When a user checks the checkbox "Pick up where I left off" on the apicall form, 
  # this method is called.  First, it finds the user's most recent apicall.  It 
  # checks to see if s/he specified an "until" date.  If so, we pick up on that date.  
  # Otherwise, we pick up on the date when the user last archived statuses.
    def DateFormatter.set_since(user_apicalls)
      # Sort the user's apicalls to find the most recent one
      set = (user_apicalls.sort do |a,b| b.created_at <=> a.created_at end).to_a
         # If they specified an until date, use that.
         if set[0][:until]
            @since = set[0][:until] 
         # Otherwise, use the apicall's 'created_at' date.  Since this value is 
         # stored as a datetime, we need to change it into the proper string format.
         elsif set[0][:created_at]
            date = (set[0][:created_at].to_date).to_s
            year = DateFormatter.get_value_from_regex(RYEAR, date)
            month_number = DateFormatter.get_value_from_regex(RMONTH_NUMBER, date)
            monthy = DateFormatter.find_month(month_number)
            day = DateFormatter.get_value_from_regex(RDATE_A, date)
            @since = day + " " + monthy + " " + year
          else @since = nil
         end
      return @since
    end

  # FORMAT 'datetime_string'
  # Takes a datetime and uses regular expressions to find the year, month, date,
  # hour, and minute.  Then, it forms a string from these values.
    def DateFormatter.format_datetime_string(updated_time)
      @year = DateFormatter.get_value_from_regex(RYEAR, updated_time)
      month_number = DateFormatter.get_value_from_regex(RMONTH_NUMBER, updated_time)
      @month = DateFormatter.find_month(month_number)
      @date = DateFormatter.get_value_from_regex(RDATE_S, updated_time)
      # if the date's first digit is '0', cut it off
        if @date.split('')[0] == "0"
          @date = @date[1,1]
        end
      military_hour = DateFormatter.get_value_from_regex(RHOUR, updated_time)
      @hour = DateFormatter.find_hour(military_hour.to_i)
      @minute = DateFormatter.get_value_from_regex(RMINUTE, updated_time)
    
      # Concatenate month, date, year, hour, and minute into a string.
      @datetime_string = @month + " " + @date + ", " + @year + " " + @hour + ":" + @minute + " " + @ampm
      return @datetime_string
    end

  # GET VALUE FROM REGEX
    def DateFormatter.get_value_from_regex(regex, updated_time)
      if regex.match(updated_time)
        return $1
      end
    end

  # FIND MONTH (using month number)
    def DateFormatter.find_month(month_number)
      month = case month_number
	when "01" then "January"
	when "02" then "February"
	when "03" then "March"
	when "04" then "April"
	when "05" then "May"
	when "06" then "June"
	when "07" then "July"
	when "08" then "August"
	when "09" then "September"
	when "10" then "October"
	when "11" then "November"
	when "12" then "December"
        when "1" then "January"
	when "2" then "February"
	when "3" then "March"
	when "4" then "April"
	when "5" then "May"
	when "6" then "June"
	when "7" then "July"
	when "8" then "August"
	when "9" then "September"
      end
    end

  # FIND HOUR
  # Takes a 24-hour ("military") time, and converts it to
  # 12-hour time.
    def DateFormatter.find_hour(military_hour)
      if ((24 > military_hour) && (military_hour > 11))  
    	@ampm = "pm"
	if (military_hour == 12)
	  hour = military_hour
	else
	  hour = military_hour - 12
	end
      else
	@ampm = "am"
	if (military_hour == 0)
	  hour = 12
	else
	  hour = military_hour
	end
      end
      return hour.to_s
    end

end
