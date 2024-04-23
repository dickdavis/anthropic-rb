# frozen_string_literal: true

module Anthropic
  module Errors
    # Error for when the provided beta is not supported
    class UnsupportedBetaError < StandardError; end

    # Error for when a beta feature is configured incorrectly
    class InvalidBetaConfigurationError < StandardError; end

    # Error for when a beta feature is not used correctly
    class UnsupportedBetaUseError < StandardError; end
  end
end
