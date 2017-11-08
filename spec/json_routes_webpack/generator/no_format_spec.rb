# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate routes with no format" do
    before do
      App.routes.draw do
        get "/starships" => "starships#index", format: false
      end
    end

    it_behaves_like(
      "generator",
      [
        ["starships", ["GET"], "/starships", [], []]
      ]
    )
  end
end
