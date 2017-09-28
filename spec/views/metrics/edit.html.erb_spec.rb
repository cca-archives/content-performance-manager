require 'rails_helper'

RSpec.describe "metrics/edit", type: :view do
  before(:each) do
    @metric = assign(:metric, Metric.create!(
      :content_id => "MyString",
      :code => "MyString",
      :value => 1
    ))
  end

  it "renders the edit metric form" do
    render

    assert_select "form[action=?][method=?]", metric_path(@metric), "post" do

      assert_select "input[name=?]", "metric[content_id]"

      assert_select "input[name=?]", "metric[code]"

      assert_select "input[name=?]", "metric[value]"
    end
  end
end
