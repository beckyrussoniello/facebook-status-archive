class Status < ActiveRecord::Base

# The Status model stores information about an individual
# Facebook status.  Each Status belongs to a User.  Users
# request statuses in units called Apicalls, so Statuses
# also belong to Apicalls.
#
# ++++++++++++++++ SCHEMA +++++++++++++++++++++++++++++++
#  create_table "statuses", :force => true do |t|
#    t.integer  "user_id",         :null => false
#    t.integer  "apicall_id",      :null => false
#    t.string   "message",         :null => false
#    t.datetime "datetime",        :null => false
#    t.string   "datetime_string"
#  end

  belongs_to :user
  belongs_to :apicall

end
