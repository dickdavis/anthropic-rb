# frozen_string_literal: true

module Anthropic
  module Api
    module Concerns
      ##
      # Provides helpers for validating params against the API schema
      module Validatable
        def validate!(params)
          JSON::Validator.validate!(schema, params)
        rescue JSON::Schema::ValidationError => error
          raise Anthropic::Api::SchemaValidationError, error.message
        end

        def schema
          api_schema = version_config['schema']

          unless api_schema
            raise Anthropic::Api::MissingSchemaError, "Missing schema for API version: #{Anthropic.api_version}"
          end

          if beta
            beta_schema = beta_config['schema']
            raise Anthropic::Api::InvalidBetaConfigurationError, "Missing beta schema: #{beta}" unless beta_schema

            api_schema['properties'].merge!(beta_schema)
          end

          api_schema
        end
      end
    end
  end
end
