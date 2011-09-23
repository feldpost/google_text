module GoogleText
  module Parsers
    class Inbox < Base

      attr_accessor :messages

      selectors_for :message_row => 'div.gc-message-sms-row',
                    :message_from => 'span.gc-message-sms-from',
                    :message_time => 'span.gc-message-sms-time',
                    :message_text => 'span.gc-message-sms-text'

      protected

      def process
        @messages = []
        document = parse_string string
        html_fragment = parse_fragment document.to_html
        inbox = json_inbox(document)
        @messages = parse_messages(inbox['messages'], html_fragment)
      end

      def json_inbox(document)
        string = document.css('json').first.to_s.scan(/CDATA\[(.+)\]\]/).flatten
        JSON.parse(string.first)
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
          html_for page_fragment, selectors_for(:message_row) do |row|
            if html_for(row,selectors_for(:message_from)).strip! =~ /Me:/
              next
            elsif html_for(row, selectors_for(:message_time)) =~ Regexp.new(message.display_start_time)
              message.to  = 'Me'
              message.from = html_for(row, selectors_for(:message_from)).strip!.gsub!(':', '')
              message.text = html_for row, selectors_for(:message_text)
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
end