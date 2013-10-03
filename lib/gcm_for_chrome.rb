require 'gcm_for_chrome/version'
require 'json'
require 'net/http'
require 'uri'
require 'rest_client'

class GcmForChrome
  NOTIFICATION_URL  = 'https://www.googleapis.com/gcm_for_chrome/v1/messages'
  REFRESH_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'

  def initialize()
    @access_token = nil
    @access_token_expires_at = nil
    @client_id = nil
    @client_secret = nil
    @refresh_token = nil
  end

  def send_notification(channel_ids, subchannel_id, payload)
    if @access_token_expires_at < (Time.new + 10)
      set_access_token(@client_id, @client_secret, @refresh_token)
    end
    check_notification_value(channel_ids, subchannel_id, payload)
    initheader = init_header

    responses = []
    channel_ids.each do |channel_id|
      _payload = create_notification_payload(
        channel_id, subchannel_id, payload
      ).to_json
      responses.push(restclient_post(NOTIFICATION_URL, _payload, initheader))
    end

    return responses
  end

  def set_access_token(client_id, client_secret, refresh_token)
    @client_id ||= client_id
    @client_secret ||= client_secret
    @refresh_token ||= refresh_token
    @access_token, @access_token_expires_at = get_access_token(@client_id, @client_secret, @refresh_token)
  end

  def get_access_token(client_id, client_secret, refresh_token)
    response = refresh_access_token(client_id, client_secret, refresh_token)
    return response['access_token'], Time.at(Time.now + response['expires_in'].to_i)
  end

  def refresh_access_token(client_id, client_secret, refresh_token)
    payload = create_refresh_access_token_payload(client_id, client_secret, refresh_token)
    return JSON.parse(restclient_post(REFRESH_TOKEN_URL, payload))
  end

  def init_header
    return {
      'Content-Type' =>'application/json',
      'Authorization' => "Bearer #{@access_token}"
    }
  end

  def create_notification_payload(channel_id, subchannel_id, payload)
    return {
      "channelId" => channel_id,
      "subchannelId" => subchannel_id,
      "payload" => payload
    }
  end

  def create_refresh_access_token_payload(client_id, client_secret, refresh_token)
    return {
      'client_id' => client_id,
      'client_secret' => client_secret,
      'refresh_token' => refresh_token,
      'grant_type' => 'refresh_token'
    }
  end

  private

  def check_notification_value(channel_ids, subchannel_id, payload)
    raise 'Not access_token. Please set_access_token.' if @access_token == '' || @access_token == nil
    raise 'channel_ids blank.' if channel_ids == [] || channel_ids == nil ||channel_ids == ''
    raise 'subchannel_id blank.' if subchannel_id == '' || subchannel_id == nil
    raise 'payload blank.' if payload == '' || payload == nil
  end

  def restclient_post(url, payload, header = {})
    response = RestClient.post(url, payload, header)
    return response
  end
end
