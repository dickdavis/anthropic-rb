# frozen_string_literal: true

require 'httpx'

module Anthropic
  module Client
    Response = Data.define(:status, :body)

    ##
    # Provides a base class for clients
    class Base
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
end
