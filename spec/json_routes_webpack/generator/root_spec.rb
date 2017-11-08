# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate root route" do
    before do
      App.routes.draw do
        root to: "starships#index"
      end
    end

    it_behaves_like(
      "generator",
      [
        ["root", ["GET"], "/", [], []]
      ]
    )
  end
end
