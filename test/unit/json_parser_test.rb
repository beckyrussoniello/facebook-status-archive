require 'test_helper'

class JsonParserTest < ActiveSupport::TestCase
fixtures :all

  def setup
    @becky = users(:becky)
    @apicalls = [ apicalls(:three), apicalls(:five), apicalls(:four), apicalls(:one) ]
  end

# TEST encode_url METHOD
  test "encode_url method" do
# This method should properly construct a URL to call the Facebook API.
# It should work with or without 'since' and/or 'until' dates.  Below,
# we test one example with 'since' AND 'until', one with only 'since',
# one with only 'until', and one with neither.

    for i in 0..3
      apicall = @apicalls[i]
      enc_token = URI.encode(apicall[:access_token])                                       
      enc_since = URI.encode(apicall[:since]) if (i==0||i==1)
      enc_until = URI.encode(apicall[:until]) if (i==0||i==2)
      url = JsonParser.encode_url(apicall[:access_token], apicall)
      assert_equal url, case i
        when 0 then
          "#{BASE_URL}&access_token=#{enc_token}&limit=#{LIMIT}&since=#{enc_since}&until=#{enc_until}"
        when 1 then
          "#{BASE_URL}&access_token=#{enc_token}&limit=#{LIMIT}&since=#{enc_since}"
        when 2 then
          "#{BASE_URL}&access_token=#{enc_token}&limit=#{LIMIT}&until=#{enc_until}"
        when 3 then
          "#{BASE_URL}&access_token=#{enc_token}&limit=#{LIMIT}"
      end
    end
  end

# TEST extract_useful_data METHOD
# NOTE: This test needs a real, current access token from Facebook in order to work.
# These can be obtained at http://developers.facebook.com/docs/reference/api/user
# Copy-paste the access token into fixtures/apicalls.yml
  test "extract_useful_data method" do
    for i in 0..3
      url = JsonParser.encode_url(@apicalls[i][:access_token], @apicalls[i])
      @dataset = JsonParser.extract_useful_data(url)
        # The method should return an array
        class_name = @dataset.class.to_s
        assert @dataset.is_a?(Array), message = "dataset is not an Array; it is a #{class_name}"
        # Each member of the array should be a hash
        for i in @dataset
          assert i.is_a?(Hash), message = "Loop #{i}: i is not a Hash"
          # Each hash should include keys such as "message" and "updated_time"
          assert i["message"]
          assert i["updated_time"]
        end
    end
  end

# TEST get_dataset METHOD
  test "get_dataset method" do
   # This method basically just calls the encode_url method, then calls extract_useful_data
   # (tested above).  Here, we will make sure that the same results are obtained from calling
   # get_dataset directly as from calling encode_url and extract_useful_data in succession.
    dataset = JsonParser.get_dataset(@becky.apicalls.first.access_token, @becky.apicalls.first)
      # The method should return an array.
    class_name = dataset.class.to_s
        assert dataset.is_a?(Array), message = "dataset is not an Array; it is a #{class_name}"
        # Each member of the array should be a hash
        for i in dataset
          assert i.is_a?(Hash), message = "Loop #{i}: i is not a Hash"
          # Each hash should include keys such as "message" and "updated_time"
          assert i["message"]
          assert i["updated_time"]
        end
  end

# TEST get_status_info METHOD
  test "get_status_info method" do
# This method should populate a Hash with the correct user_id, apicall_id, message,
#  datetime, and datetime_string attributes.
    # First, get a dataset.  Make sure it is not nil.
    url = JsonParser.encode_url(@apicalls[1][:access_token], @apicalls[1])
    @dataset = JsonParser.extract_useful_data(url)
    assert @dataset, message = "Dataset is nil."
    # For each status, make sure the attributes are assigned properly.
    for i in 0..(@dataset.size - 1)
      status_hash = JsonParser.get_status_info(@dataset, @becky, @apicalls[1], i)
      # Verify that the hash has the correct elements.
      assert_equal status_hash.size, 5
      assert_equal status_hash[:user_id], @becky.id
      assert_equal status_hash[:apicall_id], @apicalls[1].id
      assert_equal status_hash[:message], @dataset[i]["message"]
      assert_equal status_hash[:datetime], @dataset[i]["updated_time"]
      assert_equal status_hash[:datetime_string], DateFormatter.format_datetime_string(@dataset[i]["updated_time"])
    end
  end
end


