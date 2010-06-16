GoogleText
=========

GoogleText is a SMS client library for sending and receiving free SMS through Google Voice.

For more information visit
<http://google_text.github.com/>.


Overview
--------

GoogleText is a SMS client library for sending and receiving free SMS through Google Voice. Alas, Google Voice does not yet have an API, so GoogleText uses Curl and Nokogiri to scrape and post using Google Voice web URLs.


Why?
----

Sure, there are a bunch of SMS implementations out there. And while GoogleText is pretty slow and perhaps a bit fragile sending SMS this way is also _absolutely free_ and allows both sending and receiving to and from a real free phone number. Pretty great, if you ask me, and worth the tradeoff in performance.


Prerequisites
-------------

GoogleText currently relies on the following gems:

* nokogiri
* curb
* json

Installation
------------

1. Get a Google Voice account, if don't already have one.

2. Install the gem, which should also install all the prerequisites.

   `gem install google_text`

3. Configure GoogleText someplace sensible, using the email address and password you use to log on to your Google Voice account. If you are using GoogleText in a Rails application, `config/initializers/google_text.rb` is a good place to put the configuration block:


Sample Configuration:

    GoogleText.configure do |config|
        config.email        = 'google-user'
        config.password     = 'google-password'
    end


Usage
-----

Setup:

    >> require 'rubygems'
	=> false
    >> require 'google_text'
    => true
    >> GoogleText.configure {|config| config.email, config.password = 'google-user', 'google-password'}
	=> ["google-user", "google-password"]
	
Sending a message:

    >> message = GoogleText::Message.new(:text => "Hello World!", :to => "(311) 615-4156")
	=> #<GoogleText::Message:0x102503630 @text="Hello World!", @to="3116154156">
	>> message.send
	=> #<GoogleText::Message:0x102515240 @to="3116154156", @sent_status=true, @text="Hello World!">
	>> message.sent?
	=> true
	
Receiving unread messages:

    >> messages = GoogleText::Message.unread
	=> [#<GoogleText::Message:0x1023fda38 @display_number="+3116154156", @from="(650) 265-1193", @read_status=false, @id="f298c576522c6a1ecc976c649e9826c31e017a24", @relative_start_time="3 minutes ago", @to="Me", @display_start_date_time="6/16/10 2:57 AM", @display_start_time="2:57 AM", @text="Hello World", @labels=["inbox", "unread", "sms", "all"], @start_time=1276671459139>]
	>> message = messages.first
	=> #<GoogleText::Message>
	>> message.read?
	=> false
	>> message.mark_as_read
	=> #<GoogleText::Message>
	=> message.read?
	=> true
	>> messages = GoogleText::Message.unread
	=> []
	
Acknowledgements
---------------

Many thanks to [kgautreaux](http://github.com/kgautreaux). I copied most of the code used for scraping and posting the Google Voice pages from [gvoice-ruby](http://github.com/kgautreaux/gvoice-ruby). His work was an enormous help in getting this gem done very quickly, as I'm sure reverse-engineering this took quite a bit of time and effort.
