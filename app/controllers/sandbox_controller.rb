class SandboxController < ApplicationController
  def index
    @metrics = Facts::Metric
              .joins(:dimensions_item)
              .between(from, to)
              .by_base_path(base_path)

    @total_items = @metrics.select('dimensions_items.id').distinct.count
    @pageviews = @metrics.sum(:pageviews)
    @feedex_issues = @metrics.sum(:number_of_issues)
    @number_of_pdfs = @metrics.sum(:number_of_pdfs)
    @number_of_word_files = @metrics.sum(:number_of_word_files)
    @unique_pageviews = @metrics.average(:unique_pageviews)
  end

private

  def from
    params[:from] ||= 5.days.ago.to_date
  end

  def to
    params[:to] ||= Date.yesterday
  end

  def base_path
    params[:base_path]
  end
end