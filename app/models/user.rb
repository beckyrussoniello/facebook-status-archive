class User < ActiveRecord::Base

# The User model stores information about individual
# Facebook users.  The app remembers users so that it
# can continue to provide access to data that was
# already requested, and so that it can inform returning
# users where they "left off" in recording their statuses,  
# and provide them the option to seamlessly pick
# up at that point.
#
# ++++++++++++++++ SCHEMA +++++++++++++++++++++++++++++++
#  create_table "users", :force => true do |t|
#    t.integer "fb_id",      :null => false
#    t.string  "name",       :null => false
#    t.string  "first_name"
#    t.string  "last_name"
#  end

  has_many :apicalls
  has_many :statuses

end
