# frozen_string_literal: true

module Anthropic
  ##
  # Provides bindings for the Anthropic completions API
  class Completions
    def initialize
      @endpoint = 'https://api.anthropic.com/v1/complete'
    end

    def create(max_tokens_to_sample:, model:, prompt:)
      Anthropic::Client.post(endpoint, { model:, prompt:, max_tokens_to_sample: })
    end

    private

    attr_reader :endpoint
  end
end
