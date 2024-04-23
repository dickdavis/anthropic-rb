# frozen_string_literal: true

require 'httpx'
require 'json'
require 'json-schema'

Dir[File.join(__dir__, 'anthropic/', '**', '*.rb')].each { |file| require_relative file }

##
# Namespace for anthropic-rb gem
module Anthropic
  def self.setup
    yield self
    @betas = Bootstrapper.load_betas
    @versions = Bootstrapper.load_versions
  end

  def self.reset
    @api_key = nil
    @api_host = nil
    @api_version = nil
  end

  def self.api_key
    @api_key || ENV.fetch('ANTHROPIC_API_KEY', nil)
  end

  def self.api_key=(api_key = nil)
    @api_key = api_key
  end

  def self.api_host
    @api_host || ENV.fetch('ANTHROPIC_API_HOST', 'https://api.anthropic.com')
  end

  def self.api_host=(api_host = nil)
    @api_host = api_host
  end

  def self.api_version
    @api_version || ENV.fetch('ANTHROPIC_API_VERSION', '2023-06-01')
  end

  def self.api_version=(api_version = nil)
    @api_version = api_version
  end

  def self.betas
    @betas
  end

  def self.versions
    @versions
  end

  def self.completions
    Anthropic::Api::Completions.new
  end

  def self.messages(...)
    Anthropic::Api::Messages.new(...)
  end
end
