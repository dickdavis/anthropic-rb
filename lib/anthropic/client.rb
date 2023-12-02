# frozen_string_literal: true

require 'httpx'

module Anthropic
  ##
  # Error when the request is malformed.
  class BadRequestError < StandardError; end
  ##
  # Error when the API key is invalid.
  class AuthenticationError < StandardError; end
  ##
  # Error when the account does not have permission for the operation.
  class PermissionDeniedError < StandardError; end
  ##
  # Error when the resource is not found.
  class NotFoundError < StandardError; end
  ##
  # Error when the resource already exists.
  class ConflictError < StandardError; end
  ##
  # Error when the resource cannot be processed.
  class UnprocessableEntityError < StandardError; end
  ##
  # Error when the request exceeds the rate limit.
  class RateLimitError < StandardError; end
  ##
  # Error when the server experienced an internal error.
  class InternalServerError < StandardError; end

  ##
  # Provides a client for sending HTTP requests.
  class Client
    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    def self.post(url, data)
      response = HTTPX.with(
        headers: {
          'Content-Type' => 'application/json',
          'x-api-key' => Anthropic.api_key,
          'anthropic-version' => '2023-06-01'
        }
      ).post(url, json: data)

      response_body = JSON.parse(response.body, symbolize_names: true)

      case response.status
      when 200
        response_body
      when 400
        raise Anthropic::BadRequestError, response_body
      when 401
        raise Anthropic::AuthenticationError, response_body
      when 403
        raise Anthropic::PermissionDeniedError, response_body
      when 404
        raise Anthropic::NotFoundError, response_body
      when 409
        raise Anthropic::ConflictError, response_body
      when 422
        raise Anthropic::UnprocessableEntityError, response_body
      when 429
        raise Anthropic::RateLimitError, response_body
      when 500
        raise Anthropic::InternalServerError, response_body
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity
  end
end
