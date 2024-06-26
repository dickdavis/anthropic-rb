# frozen_string_literal: true

require 'httpx'

module Anthropic
  module Client
    ##
    # Error when the server experienced an internal error.
    class ApiError < StandardError; end

    ##
    # Error when the API key is invalid.
    class AuthenticationError < StandardError; end

    ##
    # Error when the resource already exists.
    class ConflictError < StandardError; end

    ##
    # Error when the request is malformed.
    class InvalidRequestError < StandardError; end

    ##
    # Error when the resource is not found.
    class NotFoundError < StandardError; end

    ##
    # Error when the API servers are overloaded.
    class OverloadedError < StandardError; end

    ##
    # Error when the account does not have permission for the operation.
    class PermissionError < StandardError; end

    ##
    # Error when the request exceeds the rate limit.
    class RateLimitError < StandardError; end

    ##
    # Error when the resource cannot be processed.
    class UnprocessableEntityError < StandardError; end

    ##
    # Defines a data object for responses
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
