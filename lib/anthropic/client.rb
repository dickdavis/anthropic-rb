# frozen_string_literal: true

require 'httpx'

module Anthropic
  ##
  # Provides a client for sending HTTP requests.
  class Client
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
    def self.post(url, data, headers = {})
      response = HTTPX.with(
        headers: {
          'Content-Type' => 'application/json',
          'x-api-key' => Anthropic.api_key,
          'anthropic-version' => Anthropic.api_version
        }.merge(headers)
      ).post(url, json: data)

      response_body = JSON.parse(response.body, symbolize_names: true)

      case response.status
      when 200
        response_body
      when 400
        raise Anthropic::Errors::BadRequestError, response_body
      when 401
        raise Anthropic::Errors::AuthenticationError, response_body
      when 403
        raise Anthropic::Errors::PermissionDeniedError, response_body
      when 404
        raise Anthropic::Errors::NotFoundError, response_body
      when 409
        raise Anthropic::Errors::ConflictError, response_body
      when 422
        raise Anthropic::Errors::UnprocessableEntityError, response_body
      when 429
        raise Anthropic::Errors::RateLimitError, response_body
      when 500
        raise Anthropic::Errors::InternalServerError, response_body
      end
    end

    def self.post_as_stream(url, data, headers = {})
      response = HTTPX.plugin(:stream).with(
        headers: {
          'Content-Type' => 'application/json',
          'x-api-key' => Anthropic.api_key,
          'anthropic-version' => Anthropic.api_version
        }.merge(headers)
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
        raise Anthropic::Errors::BadRequestError
      when 401
        raise Anthropic::Errors::AuthenticationError
      when 403
        raise Anthropic::Errors::PermissionDeniedError
      when 404
        raise Anthropic::Errors::NotFoundError
      when 409
        raise Anthropic::Errors::ConflictError
      when 422
        raise Anthropic::Errors::UnprocessableEntityError
      when 429
        raise Anthropic::Errors::RateLimitError
      when 500
        raise Anthropic::Errors::InternalServerError
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
  end
end
