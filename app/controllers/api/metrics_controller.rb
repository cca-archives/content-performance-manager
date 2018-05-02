class Api::MetricsController < Api::BaseController
  before_action :validate_params!, except: :index

  def time_series
    @metrics = query_series
    @metric_params = metric_params
  end

  def summary
    @metrics = query_series
    @metric_params = metric_params
  end

  def index
    items = Rails.configuration.metrics.map { |k, v| v.merge(metric_id: k) }.sort_by { |item| item[:name] }
    render json: items
  end

private

  def query_series
    series = Facts::Metric
      .between(from, to)
      .by_content_id(content_id)
      .by_locale('en')
      .joins("LEFT JOIN facts_editions ON dimensions_items.id = facts_editions.dimensions_item_id")
      .order('dimensions_dates.date asc')
      .group('dimensions_dates.date')

    if facts_metrics.include?(metric)
      series.sum("facts_editions.#{metric}")
    else
      series.sum(metric)
    end
  end

  delegate :from, :to, :metric, :content_id, to: :metric_params

  def metric_params
    @metric_params ||= Api::Metric.new(params.permit(:from, :to, :metric, :content_id, :format))
  end

  def validate_params!
    unless metric_params.valid?
      error_response(
        "validation-error",
        title: "One or more parameters is invalid",
        invalid_params: metric_params.errors.to_hash
      )
    end
  end

  def facts_metrics
    %w(
      number_of_pdfs
      number_of_word_files
      readability_score
      contractions_count
      equality_count
      indefinite_article_count
      passive_count
      profanities_count
      redundant_acronyms_count
      repeated_words_count
      simplify_count
      spell_count
      string_length
      sentence_count
      word_count
    )
  end
end
