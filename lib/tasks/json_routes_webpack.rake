# frozen_string_literal: true.

namespace :json_routes_webpack do
  desc "Export app routes to json format"
  task compile: :environment do
    JsonRoutesWebpack.compile
  end
end
