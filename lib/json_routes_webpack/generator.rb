# frozen_string_literal: true

require "rails/application"
require "action_dispatch/routing/inspector"

module JsonRoutesWebpack
  class Generator
    # @return [String]
    attr_reader :file

    # @return [ActionDispatch::Routing::RouteSet]
    attr_reader :routes

    # @return [Array<Regexp>,nil] default to nil
    attr_reader :include

    # @return [Array<Regexp>,nil] default to nil
    attr_reader :exclude

    def initialize(file, routes: nil, include: nil, exclude: nil)
      @file = file
      @routes = routes || Rails.application.routes.routes
      @include = include
      @exclude = exclude
    end

    # Generate a hash of all the route definitions matching the include and exclude rules
    # and write the hash as json to the configured file
    #
    # @return [Hash]
    def generate!
      out_file = Rails.root.join(file)

      dirname = File.dirname(out_file)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

      File.open(out_file, "w") do |f|
        f.write(JSON.fast_generate(generate))
        # f.write(source.to_json)
      end
    end

    # Generate a hash of all the route definitions matching the include and exclude rules
    #
    # @return [Hash]
    def generate
      Rails.application.reload_routes!
      all_routes = collect_routes(routes)
      group_routes = group_routes(all_routes)
      routes_to_display = filter_routes(group_routes)
      { routes: routes_to_display }
    end

    private

    # collect the routes, including nested engine routes, and build the summaries we need for the json
    #
    # @param routes [Array<ActionDispatch::Routing::RouteSet>]
    # @param parent_route [ActionDispatch::Routing::RouteWrapper]
    # @return [Array<Hash>]
    def collect_routes(routes, parent_route = nil)
      routes.map do |route|
        ActionDispatch::Routing::RouteWrapper.new(route)
      end.reject(&:internal?)
            .flat_map do |route|
        route.engine? ? collect_engine_routes(route) : build_route_summary(route, parent_route)
      end
    end

    # merge the parent_route with the route returing a hash of properties that we need for the json
    #
    # @param route [ActionDispatch::Routing::RouteWrapper]
    # @param parent_route [ActionDispatch::Routing::RouteWrapper]
    # @return [Array<Hash>]
    def build_route_summary(route, parent_route = nil)
      name = [parent_route&.name, route.name].compact.join("_")
      method = parent_route&.verb.presence || route.verb
      path = "#{parent_route&.path}#{route.path}"
      required_parts = [parent_route&.required_parts, route.required_parts].compact.flatten
      parts = [parent_route&.parts, route.parts].compact.flatten

      {
        name: name,
        method: method,
        path: path,
        required_parts: required_parts,
        parts: parts
      }
    end

    # collect the routes associate with the engine route
    #
    # @param routes [ActionDispatch::Routing::RouteWrapper]
    # @return [Array<Hash>, nil]
    def collect_engine_routes(route)
      return unless route.engine?

      routes = route.rack_app.routes
      if routes.is_a?(ActionDispatch::Routing::RouteSet)
        collect_routes(routes.routes, route)
      end
    end

    # apply the include and exclude matchers
    #
    # @param routes [Array<Hash>]
    # @return [Array<Hash>]
    def filter_routes(routes)
      routes.reject do |route|
        (exclude && any_match?(route, exclude)) || (include && !any_match?(route, include))
      end
    end

    # decide if the route matches any of the matchers
    #
    # @param route [Hash]
    # @param matchers [Array<Regexp>]
    # @return [bool]
    def any_match?(route, matchers)
      matchers.any? { |pattern| route[:name] =~ pattern }
    end

    # group the routes by path, aggregate all the supported methods and compute the optional params
    #
    # @param routes [Array<Hash>]
    # @return [Array<Hash>]
    def group_routes(routes)
      routes.group_by do |route|
        route[:path]
      end.map do |path, route_group|
        methods = route_group.map { |route| route[:method] }
        named_route = route_group.find { |route| route[:name].present? } # only one of the grouped routes will have a name
        if named_route
          {
            name: named_route[:name],
            methods: methods,
            path: named_route[:path],
            required_params: named_route[:required_parts],
            optional_params: named_route[:parts] - named_route[:required_parts]
          }
        end
      end.compact
    end
  end
end
