# frozen_string_literal: true

module Anthropic
  module Client
    ##
    # Provides a client for sending standard HTTP requests.
    class Standard < Base
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
      def self.post(url, data, headers = {})
        response = HTTPX.with(
          headers: {
            'Content-Type' => 'application/json',
            'x-api-key' => Anthropic.api_key,
            'anthropic-version' => Anthropic.api_version
          }.merge(headers)
        ).post(url, json: data)

        raise response.error if response.is_a?(HTTPX::ErrorResponse)

        response_data = build_response(response.body)

        case response.status
        when 200
          response_data
        when 400
          raise Anthropic::Client::InvalidRequestError, response_data
        when 401
          raise Anthropic::Client::AuthenticationError, response_data
        when 403
          raise Anthropic::Client::PermissionError, response_data
        when 404
          raise Anthropic::Client::NotFoundError, response_data
        when 409
          raise Anthropic::Client::ConflictError, response_data
        when 422
          raise Anthropic::Client::UnprocessableEntityError, response_data
        when 429
          raise Anthropic::Client::RateLimitError, response_data
        when 500
          raise Anthropic::Client::ApiError, response_data
        when 529
          raise Anthropic::Client::OverloadedError, response_data
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
    end
  end
end
