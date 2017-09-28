require 'gds_api/publishing_api_v2'

module Clients
  class PublishingAPI
    PER_PAGE = 700

    attr_accessor :publishing_api, :per_page

    def initialize
      @publishing_api = GdsApi::PublishingApiV2.new(
        Plek.new.find('publishing-api'),
        disable_cache: true,
        bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
      )
      @per_page = 700
    end

    def fetch_all(fields)
      publishing_api
        .get_paged_editions(
          fields: fields,
          states: %w[published],
          per_page: @per_page,
        )
        .map { |response| normalise(response).fetch(:results) }
        .flatten
    end

    def fetch(content_id, locale, version = nil)
      if version
        normalise(publishing_api.get_content(content_id, locale: locale, version: version))
      else
        normalise(publishing_api.get_content(content_id, locale: locale))
      end
    end

    def links(content_id)
      normalise(publishing_api.get_links(content_id)).fetch(:links)
    end

    def find_each(fields, options = {})
      current_page = 1
      query = build_base_query(fields, options)

      loop do
        query = build_current_page_query(query, current_page)
        response = publishing_api.get_content_items(query)
        response["results"].each do |result|
          if options[:links]
            result[:links] = links(result["content_id"])
          end
          yield result.deep_symbolize_keys
        end

        break if last_page?(response)
        current_page = response["current_page"] + 1
      end
    end

    private

    def build_base_query(fields, options)
      {
        document_type: options[:document_type],
        order: options[:order] || '-public_updated_at',
        q: options[:q] || '',
        states: ['published'],
        per_page: per_page,
        fields: fields || []
      }
    end

    def build_current_page_query(query, page)
      query[:page] = page
      query
    end

    def normalise(response)
      response.to_hash.deep_symbolize_keys
    end

    def last_page?(response)
      response["current_page"] == response["pages"]
    end
  end
end
