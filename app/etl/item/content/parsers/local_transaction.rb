class Item::Content::Parsers::LocalTransaction
  def parse(json)
    html = []
    html << json.dig("details", "introduction")
    html << json.dig("details", "need_to_know")
    html << json.dig("details", "more_information")
    html.join(" ")
  end

  def schemas
    ['local_transaction']
  end
end
