class Api::MetricsController < Api::BaseController
  before_action :validate_params!, except: :index

  def time_series
    @metrics = query_series
    @api_request = api_request
  end

  def summary
    @metrics = query_series
    @api_request = api_request
  end

  def index
    items = Metric.find_all
    render json: items
  end

private

  def query_series
    series = Facts::Metric
      .between(from, to)
      .by_content_id(content_id)
      .by_locale('en')

    if Metric.is_edition_metric?(metric)
      series
        .with_edition_metrics
        .order('dimensions_dates.date asc')
        .pluck(:date, "facts_editions.#{metric}").to_h
    else
      series
        .order('dimensions_dates.date asc')
        .pluck(:date, metric).to_h
    end
  end

  delegate :from, :to, :metric, :content_id, to: :api_request

  def api_request
    @api_request ||= Api::Request.new(params.permit(:from, :to, :metric, :content_id, :format))
  end

  def validate_params!
    unless api_request.valid?
      error_response(
        "validation-error",
        title: "One or more parameters is invalid",
        invalid_params: api_request.errors.to_hash
      )
    end
  end
end
