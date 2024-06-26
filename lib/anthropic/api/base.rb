# frozen_string_literal: true

require_relative 'concerns/requestable'
require_relative 'concerns/validatable'

module Anthropic
  module Api
    # Error for when a beta feature is configured incorrectly.
    class InvalidBetaConfigurationError < StandardError; end

    # Error for when API version is missing a schema.
    class MissingSchemaError < StandardError; end

    # Error for when the provided params do not match the API schema
    class SchemaValidationError < StandardError; end

    # Error for when the API version is not supported.
    class UnsupportedApiVersionError < StandardError; end

    # Error for when the provided beta is not supported.
    class UnsupportedBetaError < StandardError; end

    ##
    # Provides a base class for APIs
    class Base
      include Anthropic::Api::Concerns::Requestable
      include Anthropic::Api::Concerns::Validatable

      def initialize(beta: nil)
        @beta = beta
      end

      private

      attr_reader :beta

      def api
        self.class.name.split('::').last.downcase
      end

      def version_config
        return @version_config if defined?(@version_config)

        @version_config ||= catch(:version_found) do
          found_config = Anthropic.versions[api.to_sym].find { |config| config['version'] == Anthropic.api_version }
          unless found_config
            raise Anthropic::Api::UnsupportedApiVersionError, "Unsupported API version: #{Anthropic.api_version}"
          end

          throw :version_found, found_config
        end
      end

      def beta_config
        return @beta_config if defined?(@beta_config)

        @beta_config = catch(:beta_found) do
          found_config = Anthropic.betas.find { |config| config['id'] == beta }
          raise Anthropic::Api::UnsupportedBetaError, "#{beta} not supported" unless found_config

          throw :beta_found, found_config
        end
      end

      def beta_loaded?(name)
        return false unless beta

        beta_config['id'] == name
      end
    end
  end
end
