class Importers::ContentDetails
  attr_reader :items_service, :content_id, :base_path

  def self.run(*args)
    new(*args).run
  end

  def initialize(content_id, base_path)
    @content_id = content_id
    @base_path = base_path
    @items_service = ItemsService.new
  end

  def run
    response = items_service.fetch_raw_json(base_path)
    number_of_pdfs = Performance::Metrics::NumberOfPdfs.parse(response.to_h['details'])
    item = Dimensions::Item.find_by(content_id: content_id, latest: true)
    item.update_attributes(raw_json: response, number_of_pdfs: number_of_pdfs)
  end
end