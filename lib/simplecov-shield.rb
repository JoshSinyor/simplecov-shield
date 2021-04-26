# frozen_string_literal: true

require 'simplecov'
require 'httparty'

module SimpleCov
  module Formatter
    class ShieldFormatter
      SHIELD_ROOT = 'http://img.shields.io/badge'
      STYLES = ['flat'].freeze

      @config = {
        badge_name: 'coverage',
        precision: 0,
        style: nil
      }

      def format(result)
        @result = result
        generate_shield
      end

      def generate_shield
        File.open(shield_file_path, 'w') do |file|
          file.write HTTParty.get(shield_url).parsed_response
        end
      end

      def shield_url
        url = "#{SHIELD_ROOT}/#{ERB::Util.url_encode("#{badge_name}-#{coverage_percent}%-#{color}")}.svg"
        url += "?style=#{style}" if STYLES.include? style

        url
      end

      def coverage_percent
        @coverage_percent ||= @result.covered_percent.round(precision)
      end

      class << self
        attr_reader :config
      end

      private

      def shield_file_path
        "#{SimpleCov.coverage_path}/coverage.svg"
      end

      def color
        case coverage_percent
        when 90..100
          'brightgreen'
        when 80..89
          'yellow'
        else
          'red'
        end
      end

      @config.each do |key, _val|
        define_method(key) { self.class.config[key] }
      end
    end
  end
end
