class SandboxController < ApplicationController
  include Concerns::ExportableToCSV

  def index
    respond_to do |format|
      format.html do
        @metrics = Reports::Series.new
          .for_en
          .between(from: from, to: to)
          .by_base_path(base_path)
          .by_organisation_id(organisation)

        @metrics =
          if is_content_metric?
            @metrics.with_edition_metrics.run
          else
            @metrics.run
          end

        @query_params = query_params
      end

      format.csv do
        @metrics = Reports::Series.new
          .for_en
          .between(from: from, to: to)
          .by_base_path(base_path)
          .by_organisation_id(organisation)
          .with_edition_metrics
          .run

        export_to_csv enum: CSVExport.run(@metrics, Facts::Metric.csv_fields)
      end
    end
  end

private

  def metric
    params[:metric]
  end

  def from
    params[:from] ||= 5.days.ago.to_date
  end

  def to
    params[:to] ||= Date.yesterday
  end

  def base_path
    params[:base_path]
  end

  def organisation
    params[:organisation]
  end

  def query_params
    params.permit(:from, :to, :base_path, :utf8,
      :total_items, :pageviews, :unique_pageviews, :feedex_comments,
      :number_of_pdfs, :number_of_word_files, :filter, :organisation,
      :is_this_useful_yes, :is_this_useful_no, :number_of_internal_searches,
      :contractions_count, :equality_count, :indefinite_article_count, :number_of_pdfs,
      :number_of_word_files, :passive_count, :profanities_count, :readability_score,
      :redundant_acronyms_count, :repeated_words_count, :sentence_count, :simplify_count,
      :spell_count, :string_length, :word_count, :metric)
  end

  def is_content_metric?
    Metric.content_metrics.any? { |metric| params[metric] == 'on' }
  end
end
