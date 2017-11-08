# frozen_string_literal: true

module AdminEngine
  class Engine < Rails::Engine
    isolate_namespace AdminEngine
  end
end

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate engine routes" do
    before do
      AdminEngine::Engine.routes.draw do
        root to: "application#index"
        get "/status" => "status#index"
        resources :planets, only: %i[index create show update destroy]
      end
    end

    describe "mount" do
      before do
        App.routes.draw do
          mount AdminEngine::Engine => "admin"
        end
      end

      it_behaves_like(
        "generator",
        [
          ["admin_engine_root", ["GET"], "/admin/", [], []],
          ["admin_engine_status", ["GET"], "/admin/status(.:format)", [], [:format]],
          ["admin_engine_planets", %w[GET POST], "/admin/planets(.:format)", [], [:format]],
          ["admin_engine_planet", %w[GET PATCH PUT DELETE], "/admin/planets/:id(.:format)", [:id], [:format]]
        ]
      )
    end

    describe "mount with as: prefixes the names" do
      before do
        App.routes.draw do
          mount AdminEngine::Engine => "admin", as: "admin"
        end
      end

      it_behaves_like(
        "generator",
        [
          ["admin_root", ["GET"], "/admin/", [], []],
          ["admin_status", ["GET"], "/admin/status(.:format)", [], [:format]],
          ["admin_planets", %w[GET POST], "/admin/planets(.:format)", [], [:format]],
          ["admin_planet", %w[GET PATCH PUT DELETE], "/admin/planets/:id(.:format)", [:id], [:format]]
        ]
      )
    end

    describe "mount with :paramter prefixes the paths and adds to the required parameters" do
      before do
        App.routes.draw do
          mount AdminEngine::Engine => "admin/:version"
        end
      end

      it_behaves_like(
        "generator",
        [
          ["admin_engine_root", ["GET"], "/admin/:version/", [:version], []],
          ["admin_engine_status", ["GET"], "/admin/:version/status(.:format)", [:version], [:format]],
          ["admin_engine_planets", %w[GET POST], "/admin/:version/planets(.:format)", [:version], [:format]],
          ["admin_engine_planet", %w[GET PATCH PUT DELETE], "/admin/:version/planets/:id(.:format)", %i[version id], [:format]]
        ]
      )
    end

    describe "as routes argument to the  generator" do
      expected_routes =
        [
          ["root", ["GET"], "/", [], []],
          ["status", ["GET"], "/status(.:format)", [], [:format]],
          ["planets", %w[GET POST], "/planets(.:format)", [], [:format]],
          ["planet", %w[GET PATCH PUT DELETE], "/planets/:id(.:format)", [:id], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:routes) { AdminEngine::Engine.routes.routes }
      end
    end
  end
end
