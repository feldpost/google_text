module GoogleText
  module Parsers
    class Dashboard < Base
      attr_accessor :session_id
      selectors_for :session_id => 'form#gc-search-form'

      protected

      def process
        section = html_for parse_document(@string), selectors_for(:session_id)
        @session_id = section.match(/value="(.+)"/)[1]
      end

    end
  end
end