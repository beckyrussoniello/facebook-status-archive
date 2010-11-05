ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

# === HELPERS FOR INTEGRATION TESTS ===

# REGULAR USER
  def regular_user
    open_session do |user|

    # USER LOGS IN
      def user.logs_in(fixture)
    # Logs the user in, and asserts session[:user_id] has been properly set.
    # We have to use post_callback_mock instead of post_callback because the
    # latter involves interacting with a real cookie from Facebook.  I tried 
    # to stub it out in a regular mock file, but apparently you can't stub out
    # controllers.  So I added a controller method just for the test.
        get "users/post_callback_mock", { :current_fb_user => 
					 {:name => fixture.name, 
					  :first_name => fixture.first_name, 
					  :last_name => fixture.last_name, 
					  :id => fixture.fb_id} }, {}
        assert_not_nil session[:user_id], message = "session[:user_id] is nil"
        assert_redirected_to "/"
        assert_equal "http://www.example.com/", redirect_to_url
        follow_redirect!()
        assert_template "index"
      end

    # USER LOGS IN FOR THE FIRST TIME
      def user.logs_in_for_the_first_time(attributes)
      # Creates a new User.
        @user = User.new(attributes = attributes)
        assert @user.save!
      # Logs the user in and asserts that they are redirected to the
      # main page.
        get "users/post_callback_mock", { :current_fb_user => 
					 {:name => @user.name, 
					  :first_name => @user.first_name, 
		 			  :last_name => @user.last_name, 
					  :id => @user.fb_id} }, {}
        assert_not_nil session[:user_id], message = "session[:user_id] is nil"
        assert_redirected_to "/"
        assert_equal "http://www.example.com/", redirect_to_url
        follow_redirect!()
        assert_template "index"
      end

    # USER IS VIEWING THE MAIN PAGE
      def user.is_viewing_the_main_page
        get "/"
        assert_response :success
        assert_template "index"
      end

    # USER REQUESTS STATUSES IN HTML
      def user.requests_statuses_in_html(apicall)
        # This method creates a simple apicall, and asserts that the
        # app fills it with statuses and displays the results to the user.
        post "apicalls/create", { :apicall => apicall, 
				  :access_token => @access_token }
        assert_equal "HTML", assigns(:apicall).output_format
        assert_not_nil session[:apicall]
          if(apicall[:left_off]=="1"||apicall[:left_off]==true)
            assert apicall_picks_up_where_user_left_off(session[:user_id])
          end
        assert_statuses_are_properly_created("HTML")
        assert_redirected_to "apicalls/show/#{assigns(:apicall).id}"
        follow_redirect!()
      end

    # USER VIEWS NEW STATUSES IN HTML
      def user.views_their_new_statuses_in_html
        assert_template "show"
      end

    # USER REQUESTS STATUSES IN RTF
      def user.requests_statuses_in_rtf(apicall)
        # This method creates a simple RTF apicall.  It asserts that
        # the response is a Proc (doesn't render anything).  Using
        # StringIO, it converts the response to a String and asserts
        # that it does not raise any errors.
        post_via_redirect "apicalls/create", { :apicall => apicall, 
					       :access_token => "a_valid_access_token" }
          if(apicall[:left_off]=="1"||apicall[:left_off]==true)
            assert apicall_picks_up_where_user_left_off(session[:user_id])
            assert_nil User.find(session[:user_id]).apicalls.last[:until]
          end
        assert(@response.body.is_a? Proc)
        require 'stringio'
        output = StringIO.new
        output.binmode
        assert_nothing_raised { @response.body.call(@response, output) }
      end   
  
    # USER RECEIVED ALL THE STATUSES THAT THEY SHOULD HAVE
      def user.received_all_the_statuses_that_they_should_have
        apicall = User.find(session[:user_id]).apicalls.last
        verify_number_of_statuses(apicall.access_token, apicall)
      end

    # VERIFY NUMBER OF STATUSES
      def user.verify_number_of_statuses(access_token, apicall)
        # This method compares the number of statuses created in an apicall to the
        # number of statuses received as JSON from Facebook.  First, we get the 
        # data from Facebook.
        dataset = JsonParser.get_dataset(access_token, apicall)
        assert_not_nil dataset, message = "dataset is nil"
        # Next, we assert that the apicall has more than zero statuses.
        assert assigns(:apicall).statuses.size > 0, 
					message = "apicall has no statuses"
        # Finally, we assert that the new apicall has the same number of statuses
        # as the dataset from Facebook.
        assert_equal dataset.size, apicall.statuses.size
      end

    # ASSERT THAT STATUSES ARE PROPERLY CREATED
      def user.assert_statuses_are_properly_created(format)
        # This method tests whether the status/create_statuses action creates the 
        # correct number of statuses and receives flash[:format] from the previous
        # action.
        assert_redirected_to "status/create_statuses"
        follow_redirect!()
        apicall = assigns(:apicall)
        assert_not_nil apicall
        assert_not_nil assigns(:user)
        verify_number_of_statuses(apicall.access_token, apicall)
        assert_equal "HTML", flash[:format]
      end

    # USER NOW HAS ONE APICALL
      def user.now_has_one_apicall
        # This method is called after a first-time user makes their first
        # apicall.
        user = User.find(session[:user_id])
        # It asserts that the app's most recently created apicall has a 
        # user_id which matches the current user's id.
        assert_equal user.id, Apicall.find(:all).last.user_id
        # Then, it makes sure that the user only has one apicall.
        assert_equal 1, user.apicalls.size
      end

    # USER VIEWS PAST ACTIVITY
      def user.views_past_activity
        # This method tests that the Past Activity page displays all 
        # of the user's past apicalls.  
        # First, it gets the Past Activity page.
        get "users/past_activity"
        assert_response :success
        assert_template "past_activity"
        # Then, it counts the user's past apicalls.
        user = User.find(session[:user_id])
        number = user.apicalls.size
        # Finally, it assert thats the page contains an entry for each 
        # past apicall.  An entry should contain the date and time that the 
        # apicall was made, along with a descriptive sentence of the activity.
        assert_select("tr td.datetime", :count => number)
        assert_select("tr td.past-activity", :count => number)
      end

    # USER SEES APP DESCRIPTION AND NEW APICALL FORM
      def user.sees_app_description_and_new_apicall_form
        # When a first-time user logs in to the app, the main page
        # displays a description of the app, along with the new
        # apicall form.
        assert_select "section#app_description"
        assert_select "section.form"
      end

    # USER SEES PAST ACTIVITY SECTION AND NEW APICALL FORM
      def user.sees_past_activity_section_and_new_apicall_form
        # When a returning user logs in to the app, the main page
        # displays the user's past activity, along with the new
        # apicall form.
        assert_select "section.past_activity"
        assert_select "section.form"
      end

    # USER IS STILL THERE
      def user.is_still_there
        # A user's session[:user_id] should not be nil after a different
        # user logs out.
        assert_not_nil session[:user_id]
      end

    # USER LOGS OUT
      def user.logs_out
        get "users/logout"
        # session[:user_id] should be nil when the user logs out.
        assert_nil session[:user_id]
      end

    # APICALL PICKS UP WHERE USER LEFT OFF
      def user.apicall_picks_up_where_user_left_off(user_id)
        # This method tests that the app can actually pick up where the user
        # left off.  If the app succeeds, this method will return the variable
        # @boolean = true.  If it fails, boolean will be false.
        # First, we sort the user's past apicalls to find the most recent
        # (previous) one.
        user = User.find(user_id)
        set = (user.apicalls.sort do |a,b| b.created_at <=> a.created_at end)
        # Then, we convert the "since" date of the CURRENT apicall to the
        # proper date format (so that it can be compared to another date).
        new_since = fix_date(assigns(:apicall).since)
        # If the previous apicall has an "until" date, the app should consider
        # this to be where the user "left off."
        if set.second[:until]
          # First, we'll need to convert it into a date.
          old_until = fix_date(set.second[:until])
          # Then, we set @boolean to true if the old "until" date matches the
          # new "since" date.
          @boolean = (old_until == new_since)
        else
          # If the previous apicall does NOT have an "until" date, we use
          # created_at instead.  We set @boolean to true if it matches the
          #  new apicall's "since" date.
          old_created_at = set.second.created_at.to_date
          @boolean = (old_created_at == new_since)
        end
        return @boolean
      end

    # FIX DATE
      def user.fix_date(field)
        # This method converts Strings into Dates.  If the String starts
        # with a space, the method deletes the space.
        if field.split('')[0] == " "
          @new_date = ("1" + field.to_s).to_date
        else
          @new_date = field.to_date
        end
        return @new_date
      end
    end
  end

# === HELPERS FOR FUNCTIONAL TESTS ===

TEST_YEAR = /(20\d{2})$/
TEST_MONTH = /\s(\w{3})\s/
TEST_DATE = /\s(\d{2})\s/
TEST_HOUR = /\s(\d{2}):/
TEST_MINUTE = /:(\d{2})/

# RTF STRING
  def rtf_string(user, apicall_id)
    # This helper method uses StringIO to determine the expected output of the 
    # apicalls/rtf action.  Once the expected output is determined, test_rtf 
    # will compare it with the actual output to make sure they are equal.
    apicall = Apicall.find(apicall_id)
    current_datetime = Time.now.to_s
    dt_values = convert_datetime_values(current_datetime)
    s = StringIO.new
    # In the real application, an actual RTF document is generated.  When this
    # is simulated (via StringIO) in the test, a String is created instead.  
    # Since it represents an RTF document, the String contains style-related markup.
    s << "{\\rtf1\\ansi\\deff0\\deflang2057\\plain\\fs24\\fet1\n{\\fonttbl\n"  
    s << "{\\f0\\froman Arial;}\n{\\f1\\fmodern Courier New;}\n}\n{\\info\n"
    s << "{\\createim\\yr#{dt_values[:year]}\\mo#{dt_values[:month_num]}\\dy" 
    s << "#{dt_values[:date]}\\hr#{dt_values[:hour]}\\min#{dt_values[:minute]}}\n}"
    s << "\n\\paperw11907\\paperh16840\\margl1800\\margr1800\\margt1440\\margb1440"
    s << "\n{\\pard\\b\\fs38\n"
    s << "Status Archive for " + user.first_name.upcase + " " + user.last_name.upcase
    s << "\n{\\line}\n\\par}\n{\\pard\n{\\b\\f1\\fs25\n\n{\\line}\n}\n"  
      @count = 1
    for status in apicall.statuses
      s << "{\\fs32"
      s << status.datetime_string
      s << "\n"
      s << status.message
      s << "\n{\\line}\n{\\line}\n}\n\\par}\n" 
      unless @count==apicall.statuses.size
        s << "{\\pard\n{\\b\\f1\\fs25\n\n" 
      end
      if @count.==apicall.statuses.size
        s << "{\\line}"
      else
        s << "{\\line}\n}\n"
      end
      @count += 1
    end
    s << "\n"
    s << "Download your statuses at "
    s << "\n{\\field\n{\\*\\fldinst\nHYPERLINK \"http://archive-fb.com\"\n}"
    s <<  "\n{\\fldrslt \\ul\nhttp://archive-fb.com\n}\n}\n!\n}"
    return s
  end

# CONVERT DATETIME VALUES
  def convert_datetime_values(current_datetime)
    # Uses DateFormatter and some test helper methods to populate a hash 
    # with values for the current year, month number, date, hours, and minute.  
    # These will be used in the StringIO simulation of app's RTF action.
    dt_values = {}
    dt_values[:year] = DateFormatter.get_value_from_regex(TEST_YEAR, current_datetime)
    month = DateFormatter.get_value_from_regex(TEST_MONTH, current_datetime)
    dt_values[:month_num] = find_month_num(month)
    date = DateFormatter.get_value_from_regex(TEST_DATE, current_datetime)
    dt_values[:hour] = DateFormatter.get_value_from_regex(TEST_HOUR, current_datetime)
    minute = DateFormatter.get_value_from_regex(TEST_MINUTE, current_datetime)
    dt_values[:date] = fix_value(date)
    dt_values[:minute] = fix_value(minute)
    return dt_values
  end

# FIND MONTH NUMBER
  def find_month_num(month)
    # Finds the month number based on the month abbreviation.
    month_num = case month
      when "Jan" then "1"
      when "Feb" then "2"
      when "Mar" then "3"
      when "Apr" then "4"
      when "May" then "5"
      when "Jun" then "6"
      when "Jul" then "7"
      when "Aug" then "8"
      when "Sep" then "9"
      when "Oct" then "10"
      when "Nov" then "11"
      when "Dec" then "12"
    end
    return month_num
  end

# FIX VALUES
  def fix_value(field)
    # Remove leading zeros.
      if field.split('')[0] == "0"
        field = field[1,1]
      end
    return field
  end

end

