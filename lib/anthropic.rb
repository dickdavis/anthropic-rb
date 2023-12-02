# frozen_string_literal: true

require 'httpx'

require_relative 'anthropic/version'
require_relative 'anthropic/client'

##
# Namespace for anthropic-rb gem
module Anthropic
  ##
  # Default error class
  class Error < StandardError; end

  def self.setup
    yield self
  end

  def self.api_key
    @api_key
  end

  def self.api_key=(api_key = nil)
    @api_key = api_key || ENV.fetch('ANTHROPIC_API_KEY', nil)
  end
end
