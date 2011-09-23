module GoogleText
  module Parsers
    class Base
      attr_accessor :string

      def self.selectors_for(symbol_or_hash)
        if symbol_or_hash.respond_to?(:keys)
          @selectors = symbol_or_hash
        else
          @selectors[symbol_or_hash]
        end
      end

      def initialize(string)
        @string = string
        process
      end

      protected

      def selectors_for(*args)
        self.class.selectors_for(*args)
      end

      def process
        raise "Not implemented"
      end

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

      def parse_string(string)
        Nokogiri::XML.parse(string)
      end


    end
  end
end