require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'json'

describe GcmForChrome do
  ACCESS_TOKEN  = 'TESTACCESS_TOKEN'
  CLIENT_ID     = 'TESTCLIENT_ID' 
  CLIENT_SECRET = 'TESTCLIENT_SECRET'
  REFRESH_TOKEN = 'TESTREFRESH_TOKEN'

  before do
    RestClient.stub(:post) do |url, payload, header|
      {
        access_token: ACCESS_TOKEN 
      }.to_json
    end
    @gcmc = GcmForChrome.new
  end

  it "get_access_token" do
    access_token = @gcmc.get_access_token(CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN)
    access_token.should == ACCESS_TOKEN
  end

  it "refresh_access_token" do
    response = @gcmc.refresh_access_token(CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN)
    response.instance_of?(JSON)
  end

  describe "init_header" do
    it "access_token blank" do
      @gcmc.init_header.should == {
        'Content-Type' =>'application/json',
        'Authorization' => "Bearer "
      }
    end

    it "set_access_token" do
      @gcmc.set_access_token(CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN)
      @gcmc.init_header.should == {
        'Content-Type' =>'application/json',
        'Authorization' => "Bearer #{ACCESS_TOKEN}"
      }
    end
  end

  it "create_notification_payload" do
    channel_id = 'test'
    subchannel_id = '0'
    payload = {test: 'hoge'}
    @gcmc.create_notification_payload(channel_id, subchannel_id, payload).should == {
      "channelId" => channel_id,
      "subchannelId" => subchannel_id,
      "payload" => payload
    }
  end

  it "create_refresh_access_token_payload" do
    @gcmc.create_refresh_access_token_payload(CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN).should == {
      'client_id' => CLIENT_ID,
      'client_secret' => CLIENT_SECRET,
      'refresh_token' => REFRESH_TOKEN,
      'grant_type' => 'refresh_token'
    }
  end

  describe "sent_notification" do
    channel_ids = ['test1', 'test2']
    subchannel_id = '0'
    payload = {title: 'test'}.to_json

    it "access_token blank" do
      proc {
        @gcmc.send_notification(channel_ids, subchannel_id, payload)
      }.should raise_error
    end
    it "channel_ids blank" do
      proc {
        @gcmc.send_notification([], subchannel_id, payload)
      }.should raise_error
    end
    it "subchannel_id blank" do
      proc {
        @gcmc.send_notification(channel_ids, '', payload)
      }.should raise_error
    end
    it "payload blank" do
      proc {
        @gcmc.send_notification(channel_ids, subchannel_id, '')
      }.should raise_error
    end
    it "success" do
      @gcmc.set_access_token(CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN)
      responses = @gcmc.send_notification(channel_ids, subchannel_id, payload)
      responses.instance_of?(Array)
    end
  end
end
