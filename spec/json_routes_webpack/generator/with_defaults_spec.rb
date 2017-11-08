# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  # defaults don't affect te route generation only the way the route is resovled by the controller
  describe "#generate for routes with defaults" do
    before do
      App.routes.draw do
        get "/starships" => "starships#index", defaults: { affiliation: "federation", format: :json }
      end
    end

    it_behaves_like(
      "generator",
      [
        ["starships", ["GET"], "/starships(.:format)", [], [:format]]
      ]
    )
  end
end
