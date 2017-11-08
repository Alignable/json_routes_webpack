# frozen_string_literal: true

RSpec.describe JsonRoutesWebpack::Generator do
  describe "#generate required parameters routes" do
    describe "single param" do
      before do
        App.routes.draw do
          get "/logs/:date" => "logs#index", as: :logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["logs", ["GET"], "/logs/:date(.:format)", [:date], [:format]]
        ]
      )
    end

    describe "multiple params" do
      before do
        App.routes.draw do
          get "/starthips/:starship_id/logs/:date" => "starship_logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "/starthips/:starship_id/logs/:date(.:format)", %i[starship_id date], [:format]]
        ]
      )
    end

    describe "lots of params" do
      before do
        App.routes.draw do
          get "/startships/:starship_id/logs/:year/:month/:day" => "starship_logs#index", as: :starship_logs
        end
      end

      it_behaves_like(
        "generator",
        [
          ["starship_logs", ["GET"], "/startships/:starship_id/logs/:year/:month/:day(.:format)", %i[starship_id year month day], [:format]]
        ]
      )
    end
  end
end
