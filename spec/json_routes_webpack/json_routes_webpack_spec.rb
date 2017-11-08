# frozen_string_literal: true


RSpec.describe JsonRoutesWebpack do
  shared_examples "it adds routes" do |routes|
    it "configures generators" do
      described_class.configure do |config|
        routes.each { |route| config.add_routes(route[:file], routes: route[:routes], include: route[:include], exclude: route[:exclude]) }
      end

      expect(described_class.configuration.generators.length).to eq routes.length

      routes.each_with_index do |route, i|
        generator = described_class.configuration.generators[i]
        expect(generator.file).to eq route[:file]
        expect(generator.include).to eq route[:include]
        expect(generator.exclude).to eq route[:exclude]
      end
    end

    after do
      described_class.reset
    end
  end

  describe "#configure" do
    describe "with file" do
      it_behaves_like "it adds routes", [{ file: "my/path/routes.json" }]
    end

    describe "with include" do
      it_behaves_like "it adds routes", [{ file: "my/path/routes.json", include: [/starship/] }]
    end

    describe "with exclude" do
      it_behaves_like "it adds routes", [{ file: "my/path/routes.json", exclude: [/planets/] }]
    end

    describe "with include and exclude" do
      it_behaves_like "it adds routes", [{ file: "my/path/routes.json", include: [/starship/], exclude: [/planets/] }]
    end

    describe "with multiple files" do
      it_behaves_like "it adds routes", [
        { file: "my/path/routes.json", include: [/starship/], exclude: [/admin/] },
        { file: "my/path/admin_routes.json", include: [/admin/] }
      ]
    end
  end

  describe "#compile" do
    def mock_generator
      generator = instance_double("JsonRoutesWebpack::Generator")
      expect(generator).to receive(:generate!)
      generator
    end

    it "generates to configured routes" do
      expect(described_class.configuration).to receive(:generators).and_return [mock_generator, mock_generator]

      described_class.compile
    end
  end
end
