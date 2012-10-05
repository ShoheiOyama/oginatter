class TwitterApi
  require 'rest_client'
  require 'pp'
  require 'rexml/document'

  API_HTTP = "https://twitter.com/account/rate_limit_status.xml"

  def self.get_rest_api
    self.get_api_infomation
    return @doc.elements['/hash/remaining-hits/'].text.to_i
  end

  def self.get_reset_time
    self.get_api_infomation
    return @doc.elements['/hash/reset-time-in-seconds/'].text.to_i
  end

  def self.get_hourly_limit
    self.get_api_infomation
    return @doc.elements['/hash/hourly-limit'].text.to_i
  end

  private

  def self.get_api_infomation
    page = RestClient.get API_HTTP
    @doc = REXML::Document.new(page)
  end
end
