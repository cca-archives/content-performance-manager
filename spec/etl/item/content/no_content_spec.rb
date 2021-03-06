RSpec.describe Item::Content::Parser do
  subject { described_class.instance }

  it "handles schemas that does not have useful content" do
    no_content_schemas = %w[
      coming_soon
      completed_transaction
      external_content
      generic
      homepage
      organisations_homepage
      person
      placeholder_corporate_information_page
      placeholder_ministerial_role
      placeholder_organisation
      placeholder_policy_area
      placeholder_topical_event
      placeholer_working_group
      placeholder_world_location
      placehold_worldwide_organisation
      placeholder_person
      placeholder
      policy
      redirect
      special_route
      topic
      world_location
      vanish
    ]
    no_content_schemas.each do |schema|
      json = build_raw_json(schema_name: schema, body: "<p>Body for #{schema}</p>")
      expect(subject.extract_content(json.deep_stringify_keys)).to be_nil, "schema: '#{schema}' should return nil"
    end
  end

  def build_raw_json(body:, schema_name:)
    {
      schema_name: schema_name,
      details: {
        body: body
      }
    }
  end
end
