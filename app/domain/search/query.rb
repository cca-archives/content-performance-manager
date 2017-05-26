class Search
  class Query
    SORT_IDENTIFIERS = [
      :page_views_desc,
    ].freeze

    attr_accessor :filters, :per_page, :page, :sort

    def initialize
      self.filters = []
      self.page = 1
      self.per_page = 25
      self.sort = :page_views_desc
    end

    def filter_by(link_type:, source_ids:, target_ids:)
      filter = Filter.new(
        link_type: link_type,
        source_ids: source_ids,
        target_ids: target_ids,
      )

      raise_if_already_filtered_by_link_type(filter)
      raise_if_mixing_source_and_target(filter)

      filters.push(filter)
    end

    def page=(value)
      @page = value.to_i
      @page = 1 if @page <= 0
    end

    def per_page=(value)
      @per_page = value.to_i
      @per_page = 100 if @per_page > 100
    end

    def sort=(identifier)
      @sort = identifier
      raise_if_unrecognised_sort
    end

  private

    def raise_if_already_filtered_by_link_type(filter)
      if filters.any? { |f| f.link_type == filter.link_type }
        raise FilterError, "duplicate filter for #{filter.link_type}"
      end
    end

    def raise_if_mixing_source_and_target(filter)
      if filters.any? { |f| f.by_source? != filter.by_source? }
        raise FilterError, "attempting to filter by source and target"
      end
    end

    def raise_if_unrecognised_sort
      raise SortError, "unrecognised sort" unless SORT_IDENTIFIERS.include?(sort)
    end

    class Filter
      attr_accessor :link_type, :source_ids, :target_ids

      def initialize(link_type:, source_ids:, target_ids:)
        self.link_type = link_type
        self.source_ids = [source_ids].flatten.compact
        self.target_ids = [target_ids].flatten.compact

        if source_ids.present? && target_ids.present?
          raise FilterError, "must filter by source or target"
        end
      end

      def by_source?
        source_ids.present?
      end
    end

    class ::FilterError < StandardError; end
    class ::SortError < StandardError; end
  end
end