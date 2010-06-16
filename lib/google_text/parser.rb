module GoogleText
  class Parser
    attr_accessor :messages

    def initialize
      @messages = []
    end

    CSS_SELECTORS = {
      :session_id => 'form#gc-search-form',
      :xsrf_token => 'div.loginBox table#gaia_table input',
      :message_row => 'div.gc-message-sms-row',
      :message_from => 'span.gc-message-sms-from',
      :message_time => 'span.gc-message-sms-time',
      :message_text => 'span.gc-message-sms-text'
    }

    def session_id_from(string)
      section = html_for parse_document(string), CSS_SELECTORS[:session_id] 
      section.match(/value="(.+)"/)[1]
    end

    def xsrf_token_from(string)
      token = nil
      html_for parse_fragment(string), CSS_SELECTORS[:xsrf_token] do |input|
        if input.to_s =~ /GALX/
          token = input.to_s.scan(/value\="(.+?)"/).flatten.pop
        end
      end
      return token
    end

    def messages_from(string)
      document = Nokogiri::XML.parse string
      html_fragment = parse_fragment document.to_html
      string = document.css('json').first.to_s.scan(/CDATA\[(.+)\]\]/).flatten
      inbox = JSON.parse(string.first)
      parse_messages(inbox['messages'], html_fragment)
      return @messages
    end

    protected

    def html_for(string,selector)
      selected = string.css(selector)
      if block_given?
        selected.each do |item|
          yield(item)
        end
      else
        selected.inner_html
      end
    end

    def parse_document(string)
      Nokogiri::HTML::Document.parse(string)
    end

    def parse_fragment(string)
      Nokogiri::HTML::DocumentFragment.parse(string)
    end

    def parse_messages(json_messages, page_fragment)
      build_messages(json_messages)
      read_message_details(page_fragment)
      return @messages
    end

    def build_messages(json_messages)
      json_messages.each do |json_message|
        if json_message[1]['type'].to_i == 2
          next
        else
          @messages << parse_message(json_message)
        end
        @messages.sort_by {|message| message.start_time}
      end
    end

    def read_message_details(page_fragment)
      @messages.each do |message|
        html_for page_fragment, CSS_SELECTORS[:message_row] do |row|
          if html_for(row,CSS_SELECTORS[:message_from]).strip! =~ /Me:/
            next
          elsif html_for(row, CSS_SELECTORS[:message_time]) =~ Regexp.new(message.display_start_time)
            message.to  = 'Me'
            message.from = html_for(row, CSS_SELECTORS[:message_from]).strip!.gsub!(':', '')
            message.text = html_for row, CSS_SELECTORS[:message_text]
          else
            next
          end
        end
      end
    end
    
    def parse_message(json_array)
      message = Message.new
      message.id                      = json_array[0]
      message.start_time              = json_array[1]['startTime'].to_i
      message.read_status             = json_array[1]['isRead']
      message.display_start_time      = json_array[1]['displayStartTime']
      message.relative_start_time     = json_array[1]['relativeStartTime']
      message.display_number          = json_array[1]['displayNumber']
      message.display_start_date_time = json_array[1]['displayStartDateTime']
      message.labels                  = json_array[1]['labels']
      return message
    end

  end
end