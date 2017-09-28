require 'rails_helper'

RSpec.describe "metrics/new", type: :view do
  before(:each) do
    assign(:metric, Metric.new(
      :content_id => "MyString",
      :code => "MyString",
      :value => 1
    ))
  end

  it "renders new metric form" do
    render

    assert_select "form[action=?][method=?]", metrics_path, "post" do

      assert_select "input[name=?]", "metric[content_id]"

      assert_select "input[name=?]", "metric[code]"

      assert_select "input[name=?]", "metric[value]"
    end
  end
end
