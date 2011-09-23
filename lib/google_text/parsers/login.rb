module GoogleText
  module Parsers
    class Login < Base
      attr_accessor :xsrf_token
      selectors_for :xsrf_token => 'form#gaia_loginform input'

      protected

      def process
        @xsrf_token = nil
        html_for parse_fragment(@string), selectors_for(:xsrf_token) do |input|
          if input.to_s =~ /GALX/
            @xsrf_token = input.to_s.scan(/value\="(.+?)"/).flatten.pop
          end
        end
      end

    end
  end
end