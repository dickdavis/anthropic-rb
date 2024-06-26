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

        response_data = build_response(response.body)

        case response.status
        when 200
          response_data
        when 400
          raise Anthropic::Errors::InvalidRequestError, response_data
        when 401
          raise Anthropic::Errors::AuthenticationError, response_data
        when 403
          raise Anthropic::Errors::PermissionError, response_data
        when 404
          raise Anthropic::Errors::NotFoundError, response_data
        when 409
          raise Anthropic::Errors::ConflictError, response_data
        when 422
          raise Anthropic::Errors::UnprocessableEntityError, response_data
        when 429
          raise Anthropic::Errors::RateLimitError, response_data
        when 500
          raise Anthropic::Errors::ApiError, response_data
        when 529
          raise Anthropic::Errors::OverloadedError, response_data
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
    end
  end
end
