# frozen_string_literal: true

module Anthropic
  module Api
    module Concerns
      ##
      # Provides helpers for sending API requests
      module Requestable
        def post(params)
          Anthropic::Client::Standard.post(uri, params, additional_headers)
        end

        def post_as_stream(params, &)
          Anthropic::Client::Streaming.post(uri, params, additional_headers, &)
        end

        def uri
          "#{Anthropic.api_host}#{version_config['endpoint']}"
        end

        def additional_headers
          {}.merge(beta_headers)
        end

        def beta_headers
          return {} unless beta

          header = beta_config['header']
          raise Anthropic::Errors::InvalidBetaConfigurationError, "Missing header: #{beta}" unless header

          header
        end
      end
    end
  end
end
