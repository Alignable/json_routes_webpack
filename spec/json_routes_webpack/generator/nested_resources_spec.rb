# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate nested resources routes" do
    before do
      App.routes.draw do
        resources :starships, except: %i[new edit] do
          resources :crew_members, except: %i[new edit]
        end
      end
    end

    it_behaves_like(
      "generator",
      [
        ["starship_crew_members", %w[GET POST], "/starships/:starship_id/crew_members(.:format)", [:starship_id], [:format]],
        ["starship_crew_member", %w[GET PATCH PUT DELETE], "/starships/:starship_id/crew_members/:id(.:format)", %i[starship_id id], [:format]],
        ["starships", %w[GET POST], "/starships(.:format)", [], [:format]],
        ["starship", %w[GET PATCH PUT DELETE], "/starships/:id(.:format)", [:id], [:format]]
      ]
    )
  end
end
