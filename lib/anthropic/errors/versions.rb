# frozen_string_literal: true

module Anthropic
  module Errors
    # Error for when the API version is not supported.
    class UnsupportedApiVersionError < StandardError; end

    # Error for when API version is missing a schema.
    class MissingSchemaError < StandardError; end

    # Error for when the provided params do not match the API schema
    class SchemaValidationError < StandardError; end
  end
end
