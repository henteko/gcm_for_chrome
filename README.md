# Google Cloud Messaging for Chrome (GCM for Chrome)
[![Build Status](https://travis-ci.org/henteko/gcm_for_chrome.png?branch=master)](https://travis-ci.org/henteko/gcm_for_chrome)

GCM for Chrome sends notifications to Chrome extensions via [GCM for Chrome](http://developer.chrome.com/apps/cloudMessaging.html)


## Installation

Add this line to your application's Gemfile:

    gem 'gcm_for_chrome'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gcm_for_chrome

## Usage

```ruby
gcmc = GcmForChrome.new('your_client_id', 'your_client_secret', 'your_refresh_token')

share_data = {
  :title => 'test',
  :data  => 'hello! Chrome!!'
}.to_json
channel_ids = ['your_channel_id', 'your_channel_id2']

# Sends notification
gcmc.send_notification(channel_ids, 'subchannel_id', share_data)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

```sh
$ bundle exec rake
```

## License and copyright
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
