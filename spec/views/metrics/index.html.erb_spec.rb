require 'rails_helper'

RSpec.describe "metrics/index", type: :view do
  before(:each) do
    assign(:metrics, [
      Metric.create!(
        :content_id => "Content",
        :code => "Code",
        :value => 2
      ),
      Metric.create!(
        :content_id => "Content",
        :code => "Code",
        :value => 2
      )
    ])
  end

  it "renders a list of metrics" do
    render
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
