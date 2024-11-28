module Openai
  class UnauthorizedError < StandardError; end
  class TooManyRequestsError < StandardError; end
  class InternalServerError < StandardError; end
  class ServiceUnavailableError < StandardError; end
  class TimeoutError < StandardError; end

  class BaseService
    attr_reader :model

    def initialize(model: 'gpt-3.5-turbo', timeout: 10)
      @model = model
      @connection = Faraday.new(url: 'https://api.openai.com') do |f| # point1
        f.headers['Authorization'] = "Bearer #{Rails.application.credentials.OPENAI_API_KEY}"
        f.headers['Content-Type'] = 'application/json'
        f.options[:timeout] = timeout
        f.adapter Faraday.default_adapter
      end
    end

    protected

    def post_request(url: '/', body: '{}')
      response = @connection.post(url) { |req| req.body = body }
      handle_response_errors(response)
      response
    rescue Faraday::TimeoutError
      raise TimeoutError, 'リクエストがタイムアウトしました。もう一度お試しください。'
    end

    private

    def handle_response_errors(response) # point2
      case response.status
      when 200
      when 401
        raise UnauthorizedError, extract_message(response.body)
      when 429
        raise TooManyRequestsError, extract_message(response.body)
      when 500
        raise InternalServerError, extract_message(response.body)
      when 503
        raise ServiceUnavailableError, extract_message(response.body)
      else
        raise StandardError, '不明なエラーです。'
      end
    end

    def extract_message(response_body)
      extracted_message = begin
                            response_json = JSON.parse(response_body)
                            return nil unless response_json.is_a?(Hash)

                            response_json.dig("error", "message")
                          rescue JSON::ParserError
                            nil
                          end
      extracted_message || 'エラーが発生しましたが、エラーメッセージが取得できませんでした。'
    end
  end
end