module Sportradar
  module Api
    class Request

      include HTTParty

      attr_reader :url, :headers, :timeout, :api_key

      def base_setup(path, options={})
        @url = set_base(path)
        @url += format unless options[:format] == 'none'
        @headers = set_headers unless options[:format] == 'none'
        @api_key = options[:api_key]
        @timeout = options.delete(:api_timeout) || Sportradar::Api.config.api_timeout
      end

      def get(path, options={})
        base_setup(path, options)
        response = self.class.get(url, headers: headers, query: options.merge(api_key), timeout: timeout)
        rescue Net::ReadTimeout, Net::OpenTimeout
          raise Sportradar::Api::Error::Timeout
        rescue EOFError
          raise Sportradar::Api::Error::NoData
        if response.success?
          response
        else
          Sportradar::Api::Error.new(response.code, response.message, response)
        end
      end

      private

      def set_base(path)
        protocol = !!Sportradar::Api.config.use_ssl ? "https://" : "http://"
        url = "#{protocol}api.sportradar.us"
        url += path
      end

      def date_path(date)
        "#{date.year}/#{date.month}/#{date.day}"
      end

      def week_path(year, season, week)
        "#{ year }/#{ season }/#{ week }"
      end


      def format
        ".#{Sportradar::Api.config.format}" if Sportradar::Api.config.format
      end

      def set_headers
        {'Content-Type' => "application/#{Sportradar::Api.config.format}", 'Accept' => "application/#{Sportradar::Api.config.format}"}
      end

      def api_key
        raise Sportradar::Api::Error::NoApiKey
      end
    end
  end
end

