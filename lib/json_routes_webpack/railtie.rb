# frozen_string_literal: true

require "json_routes_webpack"
require "rails"

module JsonRoutesWebpack
  class Railtie < Rails::Railtie
    railtie_name :json_routes_webpack

    rake_tasks do
      load "tasks/json_routes_webpack.rake"
    end
  end
end
