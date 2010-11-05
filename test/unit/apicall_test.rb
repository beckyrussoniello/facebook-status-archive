require 'test_helper'

class ApicallTest < ActiveSupport::TestCase

  def setup
    @becky = users(:becky)
    @apicall_3 = apicalls(:three)
    @apicall_4 = apicalls(:four)
  end

# TEST MODEL ASSOCIATIONS
# apicall belongs_to :user
  test "belongs_to :user" do
    assert_equal(2, @apicall_4.user_id)
    assert_equal(2, @apicall_4.user.id)
    assert_equal("Chris Waggoner", @apicall_4.user.name)
  end

# has_many :statuses
  test "has_many :statuses" do
    assert_equal(2, @apicall_3.statuses.count)
    assert_equal([3,3], @apicall_3.statuses.collect {|w| w.apicall_id })
    assert_equal(5, @apicall_3.statuses.sort_by {|w| w.id }.first.id)
    assert_equal [statuses(:five), statuses(:six)],
                 @apicall_3.statuses
  end

# TEST VALIDATIONS
# validates_presence_of :output_format
  test "invalid without output_format" do
    fake_call = Apicall.new(:user_id => @becky.id, :access_token => "blah")
    assert !fake_call.valid?
    assert fake_call.errors.invalid?(:output_format)
  end

# Test that 'HTML' and 'Rich Text' are valid output_formats;
# 'blah' is not.
  test "validity of output_format" do
    fake_call = Apicall.new(:user_id => @becky.id, :access_token => "blah")

    fake_call.output_format = "blah"
    assert !fake_call.valid?, message = "The format validation is not working."
    assert fake_call.errors.invalid?(:output_format)

    fake_call.output_format = "HTML"
    assert fake_call.valid?

    fake_call.output_format = "Rich Text"
    assert fake_call.valid?
  end
end
