# frozen_string_literal: true

require "json_routes_webpack/configuration"

module JsonRoutesWebpack
  RSpec.describe Configuration do
    describe "#new" do
      it "starts without routes" do
        expect(Configuration.new.generators).to eq([])
      end
    end

    describe "add_routes" do
      let(:config) { Configuration.new }

      it "adds routes with file" do
        config.add_routes("/my/path/routes.json")

        expect(config.generators.length).to eq(1)

        generator = config.generators[0]
        expect(generator.file).to eq("/my/path/routes.json")
        expect(generator.include).to be_nil
        expect(generator.exclude).to be_nil
      end

      it "adds routes with include and exclude list" do
        includes = [/startship/]
        excludes = [/crew_members/]

        config.add_routes("/my/path/routes.json", include: includes, exclude: excludes)
        expect(config.generators.length).to eq(1)

        generator = config.generators[0]
        expect(generator.file).to eq("/my/path/routes.json")
        expect(generator.include).to eq includes
        expect(generator.exclude).to eq excludes
      end

      it "add multiple routes" do
        config.add_routes("/my/path/routes.json")

        config.add_routes("/my/path/admin_routes.json")

        expect(config.generators.map(&:file)).to eq(["/my/path/routes.json", "/my/path/admin_routes.json"])
      end
    end
  end
end
