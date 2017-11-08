# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate glob parameter routes" do
    describe "glob param" do
      before do
        App.routes.draw do
          get "/logs/*date" => "logs#index", as: :logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["logs", ["GET"], "/logs/*date(.:format)", [:date], [:format]]
        ]
      )
    end

    describe "optional glob param" do
      before do
        App.routes.draw do
          get "/logs(/*date)" => "logs#index", as: :logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["logs", ["GET"], "/logs(/*date)(.:format)", [], %i[date format]]
        ]
      )
    end

    describe "params before glob param" do
      before do
        App.routes.draw do
          get "/startships/:starship_id/logs/*date" => "logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "/startships/:starship_id/logs/*date(.:format)", %i[starship_id date], [:format]]
        ]
      )
    end

    describe "params after glob param" do
      before do
        App.routes.draw do
          get "/logs/*date/crew_member/:crewId" => "logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "/logs/*date/crew_member/:crewId(.:format)", %i[date crewId], [:format]]
        ]
      )
    end

    describe "optional params before glob param" do
      before do
        App.routes.draw do
          get "(/startships/:starship_id)/logs/*date" => "logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "(/startships/:starship_id)/logs/*date(.:format)", [:date], %i[starship_id format]]
        ]
      )
    end

    describe "optional params after glob param" do
      before do
        App.routes.draw do
          get "/logs/*date(/crew_member/:crewId)" => "logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "/logs/*date(/crew_member/:crewId)(.:format)", [:date], %i[crewId format]]
        ]
      )
    end
  end
end
