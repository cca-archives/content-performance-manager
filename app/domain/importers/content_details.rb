require 'odyssey'

class Importers::ContentDetails
  attr_reader :items_service, :content_id, :base_path

  def self.run(*args)
    new(*args).run
  end

  def initialize(content_id, base_path, _ = {})
    @content_id = content_id
    @base_path = base_path
    @items_service = ItemsService.new
  end

  def run
    item = Dimensions::Item.find_by(content_id: content_id, latest: true)

    item_raw_json = items_service.fetch_raw_json(base_path)
    attributes = Importers::ContentParser.parse(item_raw_json)
    item.update_attributes(attributes)

    ImportQualityMetricsJob.perform_async(item.id)
  rescue GdsApi::HTTPGone
    item.gone!
  rescue GdsApi::HTTPNotFound
    do_nothing
  end

private

  def do_nothing; end

end
