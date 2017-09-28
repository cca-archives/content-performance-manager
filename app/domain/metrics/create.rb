module Metrics
  class Create

    def self.call(content_id:, day:, metrics: {})
      @content_id = content_id
      metrics.each do

        metrics.each do |code, value|
          Metric
            .create_with(value: value)
            .find_or_create_by(
              content_id: content_id,
              day: day,
              code: code
            )
        end
      end
    end
  end
end