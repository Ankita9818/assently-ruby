require "json"
require "faraday"

module Egree
  class Client
    attr_reader :username, :password

    attr_accessor :environment

    def initialize username, password, environment = :production
      @username = username
      @password = password
      self.environment = environment
    end

    def create_case signature_case
      post "/createcasecommand", signature_case.to_json
    end

    def post url, body = nil
      response = make_post url, body

      if response.success?
        SuccessResult.new parse_response(response.body)
      else
        ErrorResult.new
      end
    end

    def host
      hosts.fetch(self.environment, hosts[:production])
    end

    def connection
      Faraday.new "https://#{host}" do |conn|
        conn.adapter :net_http
        conn.basic_auth username, password
      end
    end

    def headers
      connection.headers
    end

    private

    def make_post url, body
      connection.post do |request|
        request.url url
        request.headers["Content-Type"] = "application/json; charset=utf-8"
        request.body = body if body
      end
    end

    def parse_response body
      begin
        JSON.parse body
      rescue JSON::ParserError
        body
      end
    end

    def hosts
      {
        production: "app.egree.com",
        test: "test.underskrift.se"
      }
    end

    class SuccessResult
      attr_reader :response

      def initialize response
        @response = response
      end

      def success?
        true
      end
    end

    class ErrorResult
      def success?
        false
      end
    end
  end
end
