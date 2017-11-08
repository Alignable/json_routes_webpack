# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate singular resources routes" do
    describe "all methods" do
      before do
        App.routes.draw do
          resource :universe
        end
      end

      it_behaves_like(
        "generator",
        [
          ["new_universe", ["GET"], "/universe/new(.:format)", [], [:format]],
          ["edit_universe", ["GET"], "/universe/edit(.:format)", [], [:format]],
          ["universe", %w[GET PATCH PUT DELETE POST], "/universe(.:format)", [], [:format]]
        ]
      )
    end

    describe "restricted actions" do
      before do
        App.routes.draw do
          resource :universe, only: %i[create show]
        end
      end

      it_behaves_like(
        "generator",
        [
          ["universe", %w[GET POST], "/universe(.:format)", [], [:format]]
        ]
      )
    end
  end
end
