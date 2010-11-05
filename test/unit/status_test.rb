require 'test_helper'

class StatusTest < ActiveSupport::TestCase

  def setup
    @status_7 = statuses(:seven)
  end

# TEST MODEL ASSOCIATIONS
# status belongs_to :user
  test "belongs_to :user" do
    assert_equal(2, @status_7.user_id)
    assert_equal(2, @status_7.user.id)
    assert_equal("Chris Waggoner", @status_7.user.name)
  end

# belongs_to :apicall
  test "belongs_to :apicall" do
    assert_equal(4, @status_7.apicall_id)
    assert_equal(4, @status_7.apicall.id)
    assert_equal("HTML", @status_7.apicall.output_format)
  end
end
