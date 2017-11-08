# frozen_string_literal: true

require "json_routes_webpack"

module JsonRoutesWebpack
  class Configuration
    attr_reader :generators

    def initialize
      @generators = []
    end

    def add_routes(file, routes: nil, include: nil, exclude: nil)
      @generators.push JsonRoutesWebpack::Generator.new(file, routes: routes, include: include, exclude: exclude)
    end
  end
end
