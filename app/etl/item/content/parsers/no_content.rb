class Item::Content::Parsers::NoContent
  def parse(_json)
    nil
  end

  def schemas
    %w[
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
  end
end
