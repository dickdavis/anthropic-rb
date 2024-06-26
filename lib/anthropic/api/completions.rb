# frozen_string_literal: true

module Anthropic
  module Api
    ##
    # Provides bindings for the Anthropic completions API
    class Completions < Base
      def create(**params, &)
        validate!(params)
        return post(params) unless params[:stream]

        post_as_stream(params, &)
      end
    end
  end
end
