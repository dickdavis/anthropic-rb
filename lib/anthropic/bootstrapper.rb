# frozen_string_literal: true

require 'httpx'

module Anthropic
  ##
  # Provides methods for bootstrapping the Anthropic gem
  module Bootstrapper
    def self.load_betas
      current_dir = File.dirname(__FILE__)
      directory_path = File.join(current_dir, 'betas')

      raise "Directory not found: #{directory_path}" unless Dir.exist?(directory_path)

      file_paths = Dir.glob(File.join(directory_path, '*.json'))

      file_paths.map do |file_path|
        JSON.parse(File.read(file_path))
      end
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def self.load_versions
      current_dir = File.dirname(__FILE__)
      directory_path = File.join(current_dir, 'versions')

      raise "Directory not found: #{directory_path}" unless Dir.exist?(directory_path)

      versions = {}

      Dir.glob(File.join(directory_path, '*')).each do |subdirectory_path|
        next unless File.directory?(subdirectory_path)

        subdirectory_name = File.basename(subdirectory_path)
        file_paths = Dir.glob(File.join(subdirectory_path, '*.json'))

        versions[subdirectory_name.to_sym] = file_paths.map do |file_path|
          JSON.parse(File.read(file_path))
        end
      end

      versions
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
