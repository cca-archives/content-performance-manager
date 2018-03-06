require 'rails_helper'

RSpec.describe Facts::Metric, type: :model do
  it { is_expected.to validate_presence_of(:dimensions_date) }
  it { is_expected.to validate_presence_of(:dimensions_item) }

  let(:day0) { create(:dimensions_date, date: Date.new(2018, 1, 12)) }
  let(:day1) { create(:dimensions_date, date: Date.new(2018, 1, 13)) }
  let(:day2) { create(:dimensions_date, date: Date.new(2018, 1, 14)) }
  describe 'Filtering' do
    subject { described_class }

    it '.between' do
      item1 = create(:dimensions_item)

      create(:metric, dimensions_item: item1, dimensions_date: day0)
      metric2 = create(:metric, dimensions_item: item1, dimensions_date: day1)
      metric3 = create(:metric, dimensions_item: item1, dimensions_date: day2)

      results = subject.between(day1, day2)
      expect(results).to match_array([metric2, metric3])
    end

    it '.by_base_path' do
      item1 = create(:dimensions_item, base_path: '/path1')
      item2 = create(:dimensions_item, base_path: '/path2')

      metric1 = create(:metric, dimensions_item: item1, dimensions_date: day0)
      metric2 = create(:metric, dimensions_item: item1, dimensions_date: day1)
      metric3 = create(:metric, dimensions_item: item1, dimensions_date: day2)
      create(:metric, dimensions_item: item2, dimensions_date: day1)
      create(:metric, dimensions_item: item2, dimensions_date: day2)

      results = subject.by_base_path('/path1')
      expect(results).to match_array([metric1, metric2, metric3])
    end

    it '.by_content_id' do
      item1 = create(:dimensions_item, content_id: 'id1')
      item2 = create(:dimensions_item, content_id: 'id2')

      metric1 = create(:metric, dimensions_item: item1, dimensions_date: day0)
      metric2 = create(:metric, dimensions_item: item1, dimensions_date: day1)
      metric3 = create(:metric, dimensions_item: item1, dimensions_date: day2)
      create(:metric, dimensions_item: item2, dimensions_date: day1)
      create(:metric, dimensions_item: item2, dimensions_date: day2)

      results = subject.by_content_id('id1')
      expect(results).to match_array([metric1, metric2, metric3])
    end
  end

  describe '.metric_summary' do
    subject { described_class }
    let(:base_path) { '/the/base/path' }
    it 'returns the correct numbers' do
      item1 = create(:dimensions_item, base_path: base_path)
      item2 = create(:dimensions_item, base_path: base_path)
      create(:metric, dimensions_item: item1, dimensions_date: day0, pageviews: 3)
      create(:metric, dimensions_item: item2, dimensions_date: day0, pageviews: 5)
      create(:metric, dimensions_item: item2, dimensions_date: day1, pageviews: 2)
      results = subject.between(day0, day1).by_base_path(base_path).metric_summary
      expect(results).to eq(
        total_items: 2,
        pageviews: 10
      )
    end
  end
end
