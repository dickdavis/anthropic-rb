# frozen_string_literal: true

require 'httpx'

module Anthropic
  ##
  # Provides a client for sending HTTP requests.
  class Client
    Response = Data.define(:status, :body)

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

    # rubocop:disable Metrics/PerceivedComplexity
    def self.post_as_stream(url, data, headers = {})
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

    class << self
      private

      def build_response(response)
        response_hash = JSON.parse(response, symbolize_names: true)
        status = response_hash[:type] == 'error' ? 'failure' : 'success'
        Anthropic::Client::Response.new(status:, body: response_hash)
      end
    end
  end
end
