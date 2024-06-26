# frozen_string_literal: true

module Anthropic
  module Client
    ##
    # Provides a client for sending streaming HTTP requests.
    class Streaming < Base
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def self.post(url, data, headers = {})
        response = HTTPX.plugin(:stream).with(
          headers: {
            'Content-Type' => 'application/json',
            'x-api-key' => Anthropic.api_key,
            'anthropic-version' => Anthropic.api_version
          }.merge(headers)
        ).post(url, json: data, stream: true)

        response.each_line do |line|
          type, event = line.split(/(\w+\b:\s)/)[1..2]
          next unless type&.start_with?('data') && event

          response_data = build_response(event)
          yield response_data unless %w[ping error].include?(response_data.body[:type])
        end
      rescue HTTPX::HTTPError => error
        case error.response.status
        when 400
          raise Anthropic::Errors::InvalidRequestError
        when 401
          raise Anthropic::Errors::AuthenticationError
        when 403
          raise Anthropic::Errors::PermissionError
        when 404
          raise Anthropic::Errors::NotFoundError
        when 409
          raise Anthropic::Errors::ConflictError
        when 422
          raise Anthropic::Errors::UnprocessableEntityError
        when 429
          raise Anthropic::Errors::RateLimitError
        when 500
          raise Anthropic::Errors::ApiError
        when 529
          raise Anthropic::Errors::OverloadedError
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    end
  end
end
