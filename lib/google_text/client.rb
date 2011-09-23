module GoogleText
  class Client
    attr_accessor  :configuration, :session, :account, :xsrf_token, :session_id, :messages,
                   :login_url, :dashboard_url, :inbox_url, :mark_as_read_url, :send_url,
                   :service
    
    def initialize(options={})
      @configuration = GoogleText.configuration   
         
      [:login_url, :dashboard_url, :inbox_url, :mark_as_read_url, :send_url, :service].each do |key|
        self.send("#{key}=", options[key] || @configuration.send(key))
      end
      
      @account = Account.new(@configuration.email,@configuration.password)
      @messages = []
      establish_session
    end
    
    def login
      get_xsrf_token
      post_to_login
      get_session_id
    end
    
    def logged_in?
      !session_id.nil?
    end
    
    def get_xsrf_token
      @xsrf_token = Parsers::Login.new(login_page).xsrf_token
    end
    
    def get_session_id
      begin
        @session_id = Parsers::Dashboard.new(dashboard_page).session_id
      rescue
        raise "Could not retrieve Google Voice Session ID" 
      end
    end
    
    def send_message(phone_number,text)
      fields = fields_for 'phoneNumber' => phone_number, 'text' => text, '_rnr_se' => session_id
      post send_url, fields
    end
    
    def get_messages
      @messages = Parsers::Inbox.new(inbox_page).messages
    end
    
    def mark_as_read(id)
      fields = fields_for 'messages' => id, 'read' => 1, '_rnr_se' => session_id
      post mark_as_read_url, fields
    end
    
    def current_page
      @session.body
    end
    
    #TODO: this does not update when being forwarded, prolly need to access last response object directly
    def current_url
      @session.url
    end
    
    def inbox_page
      get inbox_url
    end
    
    def dashboard_page
      current_url == @configuration.dashboard_url ? current_page : get(dashboard_url)
    end
    
    def post_to_login
      post login_url, login_fields
    end
    
    def login_page
      get login_url 
    end
    
    def parser
      @parser ||= Parser.new
    end

    protected
    
    def establish_session
      @session ||= Session.new
    end
    
    def get(*args)
      @session.get(*args)
    end
    
    def post(*args)
      @session.post(*args)
    end
    
    def login_fields
      fields_for  'continue' => dashboard_url,
                  'service' => service,
                  'GALX' => xsrf_token,
                  'Email' => account.email,
                  'Passwd' => account.password
    end
    
    def fields_for(fields={})
      fields = fields.map do |name,value|
        value.nil? ? nil : Curl::PostField.content(name, value) 
      end
      fields.compact
    end
    
  end
end