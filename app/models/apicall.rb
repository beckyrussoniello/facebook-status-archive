class Apicall < ActiveRecord::Base

# The Apicall model class is basically a wrapper for the parameters
# a user specifies before requesting status data.  This information
# is used to call the Facebook Graph API, and also to instruct the
# app on what to do next once the data is received.
#
# The model also stores info about WHEN the user made a data request.
# This enables the app to later determine where the user "left off"
# in recording their statuses.
#
# Apicall = data request.
#
# That the Apicall "has many" Statuses means that this model also 
# _groups_ the Statuses, by the occasion on which they were
# requested.
#
# ++++++++++++++++ SCHEMA ++++++++++++++++++++++++++++++++++++++++
#  create_table "apicalls", :force => true do |t|
#    t.integer  "user_id",       :null => false
#    t.datetime "created_at"
#    t.datetime "updated_at"
#    t.string   "access_token"
#    t.string   "since"
#    t.string   "until"
#    t.boolean  "left_off"
#    t.string   "output_format"
#  end

  belongs_to :user
  has_many :statuses

  # must specify an output format of either HTML or Rich Text.
  validates_presence_of :output_format
  validates_format_of :output_format, :with => /^(HTML)|(Rich Text)$/

end
