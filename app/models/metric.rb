class Metric
  include ActiveModel::Model
  include Comparable
  attr_accessor :description, :name, :source

  def self.find_all
    @all_metrics ||= (daily_metrics + edition_metrics).sort
  end

  def self.metric_names
    self.find_all.map(&:name)
  end

  def self.is_edition_metric?(metric_name)
    edition_metrics.any? { |edition_metric| edition_metric.name == metric_name }
  end

  def self.edition_metrics_names
    edition_metrics.map(&:name)
  end

  def self.edition_metrics
    source['edition'].map { |attributes| Metric.new(attributes) }
  end

  def self.daily_metrics
    source['daily'].map { |attributes| Metric.new(attributes) }
  end

  def self.source
    @source ||= YAML.load_file(Rails.root.join('config', 'metrics.yml'))
  end

  def <=>(other)
    name <=> other.name
  end
end
