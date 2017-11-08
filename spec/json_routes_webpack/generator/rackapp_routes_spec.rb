# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate rackapp routes" do
    module AdminApp
      def self.call(_env); end
    end

    before do
      App.routes.draw do
        mount AdminApp => "admin", as: "admin"
      end
    end

    it_behaves_like(
      "generator",
      [
        ["admin", [""], "/admin", [], []]
      ]
    )
  end
end
