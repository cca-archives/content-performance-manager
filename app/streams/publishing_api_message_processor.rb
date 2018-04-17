class PublishingApiMessageProcessor
  def initialize(message)
    @content_id = message.payload.fetch('content_id')
    @base_path = message.payload.fetch('base_path')
    @payload_version = message.payload.fetch('payload_version')
    @locale = message.payload['locale'] || 'en'
    @routing_key = message.delivery_info.routing_key
  end

  def process
    item = Dimensions::Item.by_natural_key(content_id: content_id, locale: locale)

    if item
      existing_payload_version = item.publishing_api_payload_version

      if payload_version > existing_payload_version
        handle_existing(item)
      else
        # Skip out of date and repeated messages from the publishing API.
        # This is to ensure that our "latest" record is actually the latest.
        #
        # RabbitMQ guarantees at-least-once delivery when using acknowledgements,
        # so messages can be duplicated, plus we can't guarantee the order of
        # processing because we can have multiple consumers working in parallel.
        logger.info "Skipping message from publishing API: published with #{payload_version} but we've already received a message with #{item.publishing_api_payload_version}"
      end
    else
      Dimensions::Item.create_empty(
        content_id: content_id,
        base_path: base_path,
        locale: locale,
        payload_version: payload_version
      )
    end
  end

private

  attr_reader :content_id
  attr_reader :base_path
  attr_reader :payload_version
  attr_reader :locale
  attr_reader :routing_key

  def handle_existing(item)
    case routing_key
    when /major|minor/
      item.copy_to_new_outdated_version!(base_path: base_path, payload_version: payload_version)
    when /unpublish/
      new_item = item.copy_to_new_outdated_version!(base_path: base_path, payload_version: payload_version)
      new_item.gone!
    else
      # If we get a links update, or an item is republished for technical reasons,
      # don't store a new version, but update the outdated time on the previous one.
      item.outdate!
    end
  end
end
