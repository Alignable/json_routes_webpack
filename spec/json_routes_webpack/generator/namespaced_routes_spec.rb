# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate namespaced reseource routes" do
    describe "namespace" do
      describe "namespace prefixes the path" do
        before do
          App.routes.draw do
            namespace :api do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["api_starships", %w[GET POST], "/api/starships(.:format)", [], [:format]],
            ["api_starship", ["GET"], "/api/starships/:id(.:format)", [:id], [:format]]
          ]
        )
      end

      describe "as: prefixes the names" do
        before do
          App.routes.draw do
            namespace :a, as: :admin do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["admin_starships", %w[GET POST], "/a/starships(.:format)", [], [:format]],
            ["admin_starship", ["GET"], "/a/starships/:id(.:format)", [:id], [:format]]
          ]
        )
      end
    end

    describe "scope" do
      describe "scope prefixes the path" do
        before do
          App.routes.draw do
            scope "api" do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["starships", %w[GET POST], "/api/starships(.:format)", [], [:format]],
            ["starship", ["GET"], "/api/starships/:id(.:format)", [:id], [:format]]
          ]
        )
      end

      describe ":as prefixes the names" do
        before do
          App.routes.draw do
            scope as: :api do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["api_starships", %w[GET POST], "/starships(.:format)", [], [:format]],
            ["api_starship", ["GET"], "/starships/:id(.:format)", [:id], [:format]]
          ]
        )
      end

      describe ":path prefixes the paths " do
        before do
          App.routes.draw do
            scope path: :a do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like("generator",
                        [
                          ["starships", %w[GET POST], "/a/starships(.:format)", [], [:format]],
                          ["starship", ["GET"], "/a/starships/:id(.:format)", [:id], [:format]]
                        ])
      end

      describe ":as and :path prefix the names and paths" do
        before do
          App.routes.draw do
            scope as: :api, path: :a do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["api_starships", %w[GET POST], "/a/starships(.:format)", [], [:format]],
            ["api_starship", ["GET"], "/a/starships/:id(.:format)", [:id], [:format]]
          ]
        )
      end

      describe "with :paramter prefixes the paths and adds to the required parameters" do
        before do
          App.routes.draw do
            scope "api/:version" do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["starships", %w[GET POST], "/api/:version/starships(.:format)", [:version], [:format]],
            ["starship", ["GET"], "/api/:version/starships/:id(.:format)", %i[version id], [:format]]
          ]
        )
      end

      describe "with optional :paramter prefixes the paths and adds to the optional parameters" do
        before do
          App.routes.draw do
            scope "(api/:version)" do
              resources :starships, only: %i[index create show]
            end
          end
        end

        it_behaves_like(
          "generator",
          [
            ["starships", %w[GET POST], "(/api/:version)/starships(.:format)", [], %i[version format]],
            ["starship", ["GET"], "(/api/:version)/starships/:id(.:format)", [:id], %i[version format]]
          ]
        )
      end
    end
  end
end
