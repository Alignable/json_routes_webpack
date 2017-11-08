# frozen_string_literal: true


module JsonRoutesWebpack
  RSpec.describe Generator do
    describe "#generate!" do
      let(:file) { "my/path/routes.json" }
      let(:full_file_path) { Rails.root.join(file) }
      let(:generator) { Generator.new file }

      after do
        begin
          File.delete(full_file_path)
        rescue
          nil
        end
      end

      it "writes a generated routes as json" do
        expect(generator).to receive(:generate).and_return(routes: [{ spec: "route" }])

        generator.generate!

        routes_file = File.read(full_file_path)
        routes = JSON.parse(routes_file)
        expect(routes).to eq("routes" => [{ "spec" => "route" }])
      end
    end
  end
end
