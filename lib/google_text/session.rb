module GoogleText
  class Session
    def initialize
      @proxy = Curl::Easy.new do |curl|
         curl.headers["User-Agent"] = GoogleText.configuration.user_agent
         curl.follow_location = true
         curl.enable_cookies = true
       end
    end
    
    def body
      body = @proxy.body_str
      body.respond_to?(:force_encoding) ? body.force_encoding('utf-8') : body
    end
    
    def get(url)
      self.url = url
      @proxy.perform
      handle_response
    end
    
    def post(url,fields=[])
      self.url = url
      @proxy.http_post fields
      handle_response
    end
    
    def url
      @proxy.url
    end
    
    def url=(url)
      @proxy.url = url
    end
    
    def response_code
      @proxy.response_code
    end
    
    protected
    
    def handle_response
      if response_code == 200
        body
      else
        raise "Invalid Response: #{response_code}"
      end
    end
    
    
  end
end