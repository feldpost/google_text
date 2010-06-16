module GoogleText
  class Message
    attr_accessor :text, :to, :from, :start_time, :display_start_time, :relative_start_time, :display_number, :labels, :display_start_date_time, :id, :read_status, :client

    def initialize(options={})
      self.text = options[:text]
      self.to = options[:to].to_s.gsub(/\D/,'')
    end

    def self.recent
      client.login
      client.get_messages
    end

    def self.unread
      recent.find_all {|message| !message.read?}
    end

    def self.client(options={})
      @client ||= Client.new(options)
    end

    def send
      client.login
      client.send_message(to,text)
      mark_as_sent
      return self
    end

    def mark_as_read
      client.login
      client.mark_as_read(id)
      return self
    end

    def mark_as_sent
      @sent_status = true
    end

    def read?
      @read_status == true
    end

    def sent?
      @sent_status == true
    end

    def valid?
      !text.nil? && to.match(/\d{7,}/)
    end

    def client
      @client ||= self.class.client
    end

  end
end