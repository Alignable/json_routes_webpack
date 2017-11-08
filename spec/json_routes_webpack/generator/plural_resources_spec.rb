# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate plural resources" do
    describe "all methods" do
      before do
        App.routes.draw do
          resources :starships
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["new_starship", ["GET"], "/starships/new(.:format)", [], [:format]],
          ["edit_starship", ["GET"], "/starships/:id/edit(.:format)", [:id], [:format]],
          ["starship", %w[GET PATCH PUT DELETE], "/starships/:id(.:format)", [:id], [:format]]
        ]
      )
    end

    describe "restricted actions" do
      before do
        App.routes.draw do
          resources :starships, only: %i[index create show]
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["starship", ["GET"], "/starships/:id(.:format)", [:id], [:format]]
        ]
      )
    end

    describe "multiple resources" do
      before do
        App.routes.draw do
          resources :starships, :planets, only: %i[index create show]
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["starship", ["GET"], "/starships/:id(.:format)", [:id], [:format]],
          ["planets", %w[GET POST], "/planets(.:format)", [], [:format]],
          ["planet", ["GET"], "/planets/:id(.:format)", [:id], [:format]]
        ]
      )
    end
  end
end
