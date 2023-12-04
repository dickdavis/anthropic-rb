# frozen_string_literal: true

require 'httpx'

require_relative 'anthropic/client'
require_relative 'anthropic/completions'
require_relative 'anthropic/version'

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

  def self.completions
    Completions.new
  end
end
