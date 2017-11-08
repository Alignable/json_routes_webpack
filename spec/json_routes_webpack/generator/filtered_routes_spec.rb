# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate filtered routes" do
    describe "include" do
      before do
        App.routes.draw do
          resources :starships, except: %i[new edit] do
            resources :crew_members, except: %i[new edit]
          end
        end
      end

      expected_routes =
        [
          ["starship_crew_members", %w[GET POST], "/starships/:starship_id/crew_members(.:format)", [:starship_id], [:format]],
          ["starship_crew_member", %w[GET PATCH PUT DELETE], "/starships/:starship_id/crew_members/:id(.:format)", %i[starship_id id], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:includes) { [/crew_member/] }
      end
    end

    describe "multiple include" do
      before do
        App.routes.draw do
          resources :starships, except: %i[new edit] do
            resources :crew_members, except: %i[new edit]
          end
        end
      end

      expected_routes =
        [
          ["starship_crew_members", %w[GET POST], "/starships/:starship_id/crew_members(.:format)", [:starship_id], [:format]],
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:includes) { [/crew_members/, /starships/] }
      end
    end

    describe "exclude" do
      before do
        App.routes.draw do
          resources :starships, except: %i[new edit] do
            resources :crew_members, except: %i[new edit]
            resources :weapons, except: %i[new edit]
          end
        end
      end

      expected_routes =
        [
          ["starship_crew_members", %w[GET POST], "/starships/:starship_id/crew_members(.:format)", [:starship_id], [:format]],
          ["starship_crew_member", %w[GET PATCH PUT DELETE], "/starships/:starship_id/crew_members/:id(.:format)", %i[starship_id id], [:format]],
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["starship", %w[GET PATCH PUT DELETE], "/starships/:id(.:format)", [:id], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:excludes) { [/weapon/] }
      end
    end

    describe "imultiple exclude" do
      before do
        App.routes.draw do
          resources :starships, except: %i[new edit] do
            resources :crew_members, except: %i[new edit]
            resources :weapons, except: %i[new edit]
          end
        end
      end

      expected_routes =
        [
          ["starship_crew_member", %w[GET PATCH PUT DELETE], "/starships/:starship_id/crew_members/:id(.:format)", %i[starship_id id], [:format]],
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["starship", %w[GET PATCH PUT DELETE], "/starships/:id(.:format)", [:id], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:excludes) { [/weapon/, /crew_members/] }
      end
    end

    describe "include and exclude" do
      before do
        App.routes.draw do
          resources :starships, except: %i[new edit] do
            resources :crew_members, except: %i[new edit]
            resources :weapons, except: %i[new edit]
          end
          resources :planets
        end
      end

      expected_routes =
        [
          ["starship_crew_members", %w[GET POST], "/starships/:starship_id/crew_members(.:format)", [:starship_id], [:format]],
          ["starship_crew_member", %w[GET PATCH PUT DELETE], "/starships/:starship_id/crew_members/:id(.:format)", %i[starship_id id], [:format]],
          ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
          ["starship", %w[GET PATCH PUT DELETE], "/starships/:id(.:format)", [:id], [:format]]
        ]

      it_behaves_like("generator", expected_routes) do
        let(:includes) { [/starship/] }
        let(:excludes) { [/weapon/] }
      end
    end
  end
end
