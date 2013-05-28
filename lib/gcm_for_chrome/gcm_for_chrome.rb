require "json"
require "net/http"
require "uri"
require "rest_client"

class GcmForChrome
  def initialize(access_token)
    @notification_url = 'https://www.googleapis.com/gcm_for_chrome/v1/messages'
    @access_token = access_token 
  end

  def test
    return "hogehoge"
  end

  def send_notification(channel_ids, subchannel_id, payload)
    initheader = {
      'Content-Type' =>'application/json',
      'Authorization' => "Bearer #{@access_token}"
    }

    responses = []
    channel_ids.each do |channel_id|
      _payload = {
        "channelId" => channel_id,
        "subchannelId" => subchannel_id,
        "payload" => payload
      }.to_json
      responses.push(ssl_post(@notification_url, initheader, _payload))
    end

    return responses 
  end

  def self.get_access_token(client_id, client_secret, refresh_token)
    response = refresh_access_token(client_id, client_secret, refresh_token)
    return response['access_token']
  end

  def self.refresh_access_token(client_id, client_secret, refresh_token)
    refresh_token_url = 'https://accounts.google.com/o/oauth2/token'
    payload = {
      'client_id' => client_id,
      'client_secret' => client_secret,
      'refresh_token' => refresh_token,
      'grant_type' => 'refresh_token'
    }

    return JSON.parse(RestClient.post(refresh_token_url, payload))
  end

  private
  def ssl_post(url, initheader, payload)
    uri = URI.parse(url)
    response = nil
    request = Net::HTTP::Post.new(uri.request_uri, initheader)
    request.body = payload

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.start do |h|
      response = h.request(request)
    end
    return response
  end
end
