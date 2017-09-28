require 'rails_helper'

RSpec.describe "metrics/show", type: :view do
  before(:each) do
    @metric = assign(:metric, Metric.create!(
      :content_id => "Content",
      :code => "Code",
      :value => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/2/)
  end
end
