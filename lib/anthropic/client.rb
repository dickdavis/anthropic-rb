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
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
    def self.post(url, data)
      response = HTTPX.with(
        headers: {
          'Content-Type' => 'application/json',
          'x-api-key' => Anthropic.api_key,
          'anthropic-version' => Anthropic.api_version
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

    def self.post_as_stream(url, data)
      response = HTTPX.plugin(:stream).with(
        headers: {
          'Content-Type' => 'application/json',
          'x-api-key' => Anthropic.api_key,
          'anthropic-version' => Anthropic.api_version
        }
      ).post(url, json: data, stream: true)

      response.each_line do |line|
        event, data = line.split(/(\w+\b:\s)/)[1..2]
        next unless event && data

        if event.start_with?('data')
          formatted_data = JSON.parse(data, symbolize_names: true)
          yield formatted_data unless %w[ping error].include?(formatted_data[:type])
        end
      end
    rescue HTTPX::HTTPError => error
      case error.response.status
      when 400
        raise Anthropic::BadRequestError
      when 401
        raise Anthropic::AuthenticationError
      when 403
        raise Anthropic::PermissionDeniedError
      when 404
        raise Anthropic::NotFoundError
      when 409
        raise Anthropic::ConflictError
      when 422
        raise Anthropic::UnprocessableEntityError
      when 429
        raise Anthropic::RateLimitError
      when 500
        raise Anthropic::InternalServerError
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
  end
end
