# frozen_string_literal: true

module Anthropic
  module Api
    ##
    # Provides bindings for the Anthropic messages API
    class Messages < BaseApi
      def create(**params, &)
        streaming = params[:stream]
        if streaming && beta_loaded?('tools-2024-04-04')
          raise Anthropic::Errors::UnsupportedBetaUseError, 'Tool use is not yet supported in streaming mode'
        end

        validate!(params)
        return post(params) unless streaming

        post_as_stream(params, &)
      end
    end
  end
end
