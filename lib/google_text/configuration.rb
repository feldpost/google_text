module GoogleText
  class Configuration
    attr_accessor :email, :password, :login_url, :user_agent, :dashboard_url, :inbox_url, :service, :send_url, :mark_as_read_url
    
    DEFAULTS = {
      :login_url => 'https://www.google.com/accounts/ServiceLoginAuth',
      :dashboard_url => 'https://www.google.com/voice',
      :mark_as_read_url => 'https://www.google.com/voice/inbox/mark',
      :inbox_url => 'https://www.google.com/voice/inbox/recent',
      :send_url => 'https://www.google.com/voice/sms/send',
      :service => 'grandcentral',
      :user_agent => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2',
    }
    
    def initialize(options={})
      DEFAULTS.each do |key,value|
        self.send("#{key}=", options[key] || value)
      end
    end
    
    def reset!
      DEFAULTS.each do |key,value|
        self.send("#{key}=", value)
      end
    end
    
  end

  class << self
    attr_accessor :configuration
  end

  # Configure GoogleText someplace sensible,
  # like config/initializers/google_text.rb when using Rails
  #
  #
  # @example
  #   GoogleText.configure do |config|
  #     config.email     = 'google-user'
  #     config.password     = 'google-password'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end