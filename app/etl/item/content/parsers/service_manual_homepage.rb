class Item::Content::Parsers::ServiceManualHomepage
  def parse(json)
    html = []
    html << json.dig("title")
    html << json.dig("description")

    children = json.dig("links", "children")
    if children.present?
      children.each do |child|
        html << child["title"]
        html << child["description"]
      end
    end

    html.compact.join(" ")
  end

  def schemas
    ['service_manual_homepage']
  end
end
