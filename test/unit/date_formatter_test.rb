require 'test_helper'

class DateFormatterTest < ActiveSupport::TestCase
fixtures :all

  RYEAR = /(20\d{2})/	 
  RMONTH_NUMBER = /-(\d{2})-/	   
  RDATE_A = /-(\d{2})$/ 	
  RDATE_S = /-(\d{2})T/ 
  RHOUR = /T(\d{2}):/ 
  RMINUTE = /:(\d{2})/ 

  def setup 
    @apicalls = [ apicalls(:one), apicalls(:two), apicalls(:three), apicalls(:four), apicalls(:five) ]
    @apicalls_group_1 = [ apicalls(:two), apicalls(:three), apicalls(:four) ]
    @apicalls_group_2 = [ apicalls(:one), apicalls(:four), apicalls(:five) ]

    @datetimes = ["2010-10-23T13:32:33", "2010-03-08T00:00:35", "2009-01-01T12:59:59", "2009-08-11T09:41:00"]
    @dates_for_rdate_a = ["2010-10-23", "2010-03-08", "2009-01-01", "2009-08-11"]

    @possible_values = {:YEARS => ["2009", "2010"], 
			:MONTH_NUMBERS => ["01", "02", "03", "04", "05", "06", "07", "08", "09","10", "11", "12"],  
			:MINUTES => ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", 
					"14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", 
					"26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37",
                             		"38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", 
					"50", "51", "52", "53", "54", "55", "56", "57", "58", "59"] }

    @months = ["January", "February", "March", "April", "May", "June", "July", 
		"August", "September", "October", "November", "December"]

    @params_apicall_1 = {:"until(3i)"=>"10", :"since(1i)"=>"2009", :"since(2i)"=>"10", :"since(3i)"=>"19", 
			:"until(1i)"=>"2010", :"until(2i)"=>"3"}
    @params_apicall_2 = {:"until(3i)"=>"6", :"since(1i)"=>"2009", :"since(2i)"=>"4", :"until(1i)"=>"2010"}
    @params_apicall_3 = {:"since(2i)"=>"11", :"since(3i)"=>"8", :"until(1i)"=>"2010"}
    @params_apicall_4 = {:"until(3i)"=>"10", :"since(1i)"=>"2009", :"until(1i)"=>"2010", :"until(2i)"=>"3"}
  end  

# TEST REGEXES FOR DATES AND HOURS
  test "regexes for dates and hours" do
    # RDATE_S and RHOUR should be able to match correctly with datetime strings.
    regexes = [RDATE_S, RHOUR]
    for i in 0..1
      for j in 0..3
        assert regexes[i].match(@datetimes[j])
        assert_equal $1, case [i,j]
          when [0,0] then "23"
          when [0,1] then "08"
          when [0,2] then "01"
          when [0,3] then "11"
          when [1,0] then "13"
          when [1,1] then "00"
          when [1,2] then "12"
          when [1,3] then "09"
        end
      end
    end
   # RDATE_A should be able to match correctly with date strings.
    for i in 0..3
      assert RDATE_A.match(@dates_for_rdate_a[i])
      assert_equal $1, case i
        when 0 then "23"
        when 1 then "08"
        when 2 then "01"
        when 3 then "11"
      end
    end
  end

# TEST THE get_value_from_regex METHOD
  test "get_value_from_regex method" do
    for apicall in @apicalls
      # Convert each apicall's "datetime" attribute into a string for use with regexes.
      created_at = apicall.created_at.to_s
        # The setup method contains a hash of all possible values for year, month number,
        # and minutes.  Any value obtained via 'get_value_from_regex' should be included
        # in this hash.
        value = DateFormatter.get_value_from_regex(RYEAR, created_at)
        assert((@possible_values[:YEARS].include? value), 
		message = "apicall #{apicall.id} failed with YEARS.  Got value #{value}")

        value = DateFormatter.get_value_from_regex(RMONTH_NUMBER, created_at)
        assert((@possible_values[:MONTH_NUMBERS].include? value), 
		message = "apicall #{apicall.id} failed with MONTH_NUMBERS.  Got value #{value}") 

        value = DateFormatter.get_value_from_regex(RMINUTE, created_at)
        assert((@possible_values[:MINUTES].include? value), 
		message = "apicall #{apicall.id} failed with MINUTES.  Got value #{value}") 
    end
  end

# TEST find_month METHOD
  test "find_month method" do
    # This method should be able to find the name of any month, given its month number.
    for i in 1..12
      # Month numbers from 1-9 can be represented with or without a leading "0".  We
      # want to make sure the method is prepared in either case.
      if i < 10
        for j in [i.to_s, ("0" + i.to_s)]
          month = DateFormatter.find_month(j) 
          assert_equal month, @months[(i - 1)], message = "Month number #{j} was mistaken for #{month}"
        end
      else
        month = DateFormatter.find_month(i.to_s) 
        assert_equal month, @months[(i - 1)], message = "Month number #{i} was mistaken for #{month}"
      end
    end
  end

# TEST find_hour METHOD
  test "find_hour method" do
    # Method should be able to assign the appropriate 12-hour time based on 24-hour time given.
    # When given 12 it should assign 12.
    hour = DateFormatter.find_hour(12)
    assert_equal "12", hour
    # When given a number greater than 12, it should subtract 12.
    for i in 13..23
      hour = DateFormatter.find_hour(i)
      assert_equal (i - 12).to_s, hour
    end
    # When given 0, it should assign 12.
    hour = DateFormatter.find_hour(0)
    assert_equal "12", hour
    # When given a number 1-11, it should assign that same number.
    for i in 1..11
      hour = DateFormatter.find_hour(i)    
      assert_equal i.to_s, hour
    end
  end

# TEST format_datetime_string METHOD
  test "format_datetime_string method" do
    for i in 0..3
      datetime_string = DateFormatter.format_datetime_string(@datetimes[i])
      # Even given the shortest month name, etc., correct datetime_strings
      # always have at least 20 characters.
      assert(datetime_string.length >= 20)
      # Ensure that the method can operate correctly on each element in the
      # @datetimes array from the setup method. 
      assert_equal datetime_string, case i
        when 0 then "October 23, 2010 1:32 pm"
        when 1 then "March 8, 2010 12:00 am"
        when 2 then "January 1, 2009 12:59 pm"
        when 3 then "August 11, 2009 9:41 am"
      end
    end
  end

# TEST set_since METHOD
  test "set_since method" do
    # First, make sure that the method's sorting function works as intended.  It should
    # organize the user's past apicalls into an array with the most recent one first.
    sorted_list = (@apicalls_group_1.sort do |a,b| b.created_at <=> a.created_at end).to_a
    assert_equal apicalls(:four), sorted_list.first 
    # Now, the method determines on what date the user should be considered to have "left off."
    # If the most recent apicall has an "until" date, set_since should use that.
    since = DateFormatter.set_since(@apicalls_group_1)
    assert_equal since, sorted_list.first[:until]
    # If the most recent apicall does NOT have an "until" date, it should use the "created_at" date
    since = DateFormatter.set_since(@apicalls_group_2)
    assert apicall_picks_up_where_user_left_off(@apicalls_group_2, since)
  end

# TEST find_date METHOD
  test "find_date method" do
    # First, make sure the method finds the correct values for year, month_number, and day.
    # The form stores these in locations such as 'params[:apicall][:since(1i)]'.
    for i in ["since", "until"]
      date = DateFormatter.find_date(i, @params_apicall_1)
      correct_values = [["2009", "2010"], ["10", "3"], ["19", "10"]]
      for j in 1..3
        # Simulate the way the method finds each year/month_number/date value.
        variable = @params_apicall_1[("\"" + i.to_s + "(" + j.to_s + "i)" + "\"").to_sym]
        # Then check it against the correct_values.
        assert_equal variable, case i
          when 0 then correct_values[j - 1][0]
          when 1 then correct_values[j - 1][1]
        end
      end
    # Depending on whether people fill in the year, month, AND day, or instead leave some
    # fields blank, 'find_date' responds differently.  It groups potential combinations
    # of parameters into six main types of cases.  They are: (1) month, day, and year have
    # all been provided; (2) month and day only; (3) day and month only; (4) year only, or
    # day and year; (5) month only; (6) other / all blank.  Below, we test one example of
    # each of the six cases, to make sure 'find_date' responds properly.
      for apicall in [@params_apicall_2, @params_apicall_3, @params_apicall_4]
        date = DateFormatter.find_date(i, apicall)
        assert_equal date, case [i, apicall]
          when ["since", @params_apicall_2] then "April 2009"
          when ["until", @params_apicall_2] then "January 2010"
          when ["since", @params_apicall_3] then "8 November 2010"
          when ["until", @params_apicall_3] then "January 2010"
          when ["since", @params_apicall_4] then nil
          when ["until", @params_apicall_4] then "10 March 2010"
        end
      end
    end
  end
end

# HELPER METHODS

  def fix_date(field)
    if field.split('')[0] == " "
      @new_date = ("1" + field.to_s).to_date
    else
      @new_date = field.to_date
    end
    return @new_date
  end

  def apicall_picks_up_where_user_left_off(user_apicalls, since)
    set = (user_apicalls.sort do |a,b| b.created_at <=> a.created_at end)
    new_since = fix_date(since)
    if set.first[:until]
      old_until = fix_date(set.first[:until])
      @boolean = (old_until == new_since)
    else
      old_created_at = set.first.created_at.to_date
      @boolean = (old_created_at == new_since)
    end
    return @boolean
  end

