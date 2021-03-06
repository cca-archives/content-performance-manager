require 'gds_api/publishing_api_v2'

class Items::Clients::PublishingAPI
  PER_PAGE = 50

  attr_accessor :publishing_api, :per_page

  def initialize
    @publishing_api = GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      disable_cache: true,
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
    )
  end

  def fetch_all(fields)
    publishing_api
      .get_paged_editions(
        fields: fields,
        states: %w[published],
        per_page: PER_PAGE,
      )
      .map { |response| normalise(response).fetch(:results) }
      .flatten
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
