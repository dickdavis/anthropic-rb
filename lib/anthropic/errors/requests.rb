# frozen_string_literal: true

module Anthropic
  module Errors
    ##
    # Error when the request is malformed.
    class BadRequestError < StandardError; end
    ##
    # Error when the API key is invalid.
    class AuthenticationError < StandardError; end
    ##
    # Error when the account does not have permission for the operation.
    class PermissionDeniedError < StandardError; end
    ##
    # Error when the resource is not found.
    class NotFoundError < StandardError; end
    ##
    # Error when the resource already exists.
    class ConflictError < StandardError; end
    ##
    # Error when the resource cannot be processed.
    class UnprocessableEntityError < StandardError; end
    ##
    # Error when the request exceeds the rate limit.
    class RateLimitError < StandardError; end
    ##
    # Error when the server experienced an internal error.
    class InternalServerError < StandardError; end
  end
end
