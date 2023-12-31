# frozen_string_literal: true

module Anthropic
  ##
  # Provides bindings for the Anthropic messages API
  class Messages
    # Error for when the API version is not supported.
    class UnsupportedApiVersionError < StandardError; end

    ENDPOINT = 'https://api.anthropic.com/v1/messages'
    V1_SCHEMA = {
      type: 'object',
      required: %w[model messages max_tokens],
      properties: {
        model: { type: 'string' },
        messages: { type: 'array' },
        max_tokens: { type: 'integer' },
        system: { type: 'string' },
        stop_sequences: { type: 'array', items: { type: 'string' } },
        temperature: { type: 'number' },
        top_k: { type: 'integer' },
        top_p: { type: 'number' },
        metadata: { type: 'object' },
        stream: { type: 'boolean' }
      },
      additionalProperties: false
    }.freeze

    def initialize(beta: false)
      @beta = beta
    end

    def create(**params, &)
      JSON::Validator.validate!(schema_for_api_version, params)
      return Anthropic::Client.post(ENDPOINT, params, additional_headers) unless params[:stream]

      Anthropic::Client.post_as_stream(ENDPOINT, params, additional_headers, &)
    rescue JSON::Schema::ValidationError => error
      raise ArgumentError, error.message
    end

    private

    attr_reader :beta

    def schema_for_api_version
      api_version = Anthropic.api_version
      case api_version
      when '2023-06-01'
        V1_SCHEMA
      else
        raise UnsupportedApiVersionError, "Unsupported API version: #{api_version}"
      end
    end

    def additional_headers
      return {} unless beta

      { 'anthropic-beta' => 'messages-2023-12-15' }
    end
  end
end
