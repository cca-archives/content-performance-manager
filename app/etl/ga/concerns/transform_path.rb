require 'active_support/concern'

module GA::Concerns::TransformPath
  extend ActiveSupport::Concern

  def format_events_with_invalid_prefix
    events_with_prefix = Events::GA.where("page_path ~ '^\/https:\/\/www.gov.uk'")
    log(process: :ga, message: "Transforming #{events_with_prefix.count} events with page_path starting https://gov.uk")
    events_with_prefix.find_each do |event|
      transformed_attributes = transform_event_attributes(event)
      event.update_attributes(transformed_attributes)
    end
  end

private

  def transform_event_attributes(event)
    sanitised_page_path = event.page_path.remove '/https://www.gov.uk'
    duplicate_event = Events::GA.find_by(page_path: sanitised_page_path)
    attributes = { page_path: sanitised_page_path }

    if duplicate_event
      attributes[:pageviews] = event.pageviews + duplicate_event.pageviews
      attributes[:unique_pageviews] = event.unique_pageviews + duplicate_event.unique_pageviews

      duplicate_event.destroy
    end

    attributes
  end
end
