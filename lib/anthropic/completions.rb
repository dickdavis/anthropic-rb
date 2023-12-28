# frozen_string_literal: true

module Anthropic
  ##
  # Provides bindings for the Anthropic completions API
  class Completions
    # Error for when the API version is not supported.
    class UnsupportedApiVersionError < StandardError; end

    V1_SCHEMA = {
      type: 'object',
      required: %w[model prompt max_tokens_to_sample],
      properties: {
        model: { type: 'string' },
        prompt: { type: 'string' },
        max_tokens_to_sample: { type: 'integer' },
        stop_sequences: { type: 'array', items: { type: 'string' } },
        temperature: { type: 'number' },
        top_k: { type: 'integer' },
        top_p: { type: 'number' },
        metadata: { type: 'object' },
        stream: { type: 'boolean' }
      },
      additionalProperties: false
    }.freeze

    def initialize
      @endpoint = 'https://api.anthropic.com/v1/complete'
    end

    def create(**params, &)
      JSON::Validator.validate!(schema_for_api_version, params)
      return Anthropic::Client.post(endpoint, params) unless params[:stream]

      Anthropic::Client.post_as_stream(endpoint, params, &)
    rescue JSON::Schema::ValidationError => error
      raise ArgumentError, error.message
    end

    private

    attr_reader :endpoint

    def schema_for_api_version
      api_version = Anthropic.api_version
      case api_version
      when '2023-06-01'
        V1_SCHEMA
      else
        raise UnsupportedApiVersionError, "Unsupported API version: #{api_version}"
      end
    end
  end
end
