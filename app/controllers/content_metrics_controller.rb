class ContentMetricsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def stats
    @content_item = ContentItem.find_by( title: params[:title]).decorate
    @metrics = ContentMetrics.new(content: params[:body], content_item: @content_item)

    render :stats, layout: nil
  end

  def show
    @content_item = ContentItem.find_by( title: params[:title]).decorate
    @metrics = ContentMetrics.new(content: params[:body], content_item: @content_item)

    render :stats, layout: nil
  end
end