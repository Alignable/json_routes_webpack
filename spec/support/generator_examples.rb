# frozen_string_literal: true

def build_expected_routes(expected_routes)
  expected_routes.map do |expected|
    {
      name: expected[0],
      methods: expected[1],
      path: expected[2],
      required_params: expected[3],
      optional_params: expected[4]
    }
  end
end

RSpec.shared_examples "generator" do |expected_routes|
  let(:routes) { nil }
  let(:includes) { nil }
  let(:excludes) { nil }

  let(:generator) { JsonRoutesWebpack::Generator.new("/my/path/routes.json", routes: routes, include: includes, exclude: excludes) }

  it "genertes routes" do
    expect(generator.generate[:routes]).to eq build_expected_routes(expected_routes)
  end
end
