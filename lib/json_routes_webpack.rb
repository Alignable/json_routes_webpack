# frozen_string_literal: true

require "json_routes_webpack/version"
require "json_routes_webpack/configuration"
require "json_routes_webpack/generator"

require "json_routes_webpack/railtie" if defined?(Rails)

module JsonRoutesWebpack
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.compile
    JsonRoutesWebpack.configuration.generators.each(&:generate!)
  end
end
