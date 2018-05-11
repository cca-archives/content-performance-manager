FactoryBot.define do
  factory :user do
    transient do
      organisation nil
    end

    sequence(:uid) { |i| "user-#{i}" }
    sequence(:name) { |i| "Test User #{i}" }
    email 'user@example.com'
    permissions { ['signin'] }
    organisation_slug "government-digital-service"
  end

  factory :dimensions_date, class: Dimensions::Date do
    sequence(:date) { |i| i.days.ago.to_date }

    initialize_with { Dimensions::Date.build(date) }
  end

  factory :dimensions_item, class: Dimensions::Item do
    latest true
    locale 'en'
    sequence(:content_id) { |i| "content_id - #{i}" }
    sequence(:title) { |i| "title - #{i}" }
    sequence(:base_path) { |i| "link - #{i}" }
    sequence(:description) { |i| "description - #{i}" }
    sequence(:raw_json) { |i| "json - #{i}" }
    sequence(:publishing_api_payload_version)
  end

  factory :facts_edition, class: Facts::Edition do
    dimensions_date
    number_of_pdfs 0
  end

  factory :metric, class: Facts::Metric do
    dimensions_date
    dimensions_item
    pageviews 10
    unique_pageviews 5
  end

  factory :ga_event, class: Events::GA do
    trait :with_views do
      pageviews 10
      unique_pageviews 5
      process_name 'views'
    end

    trait :with_user_feedback do
      is_this_useful_yes 3
      is_this_useful_no 6
      process_name 'user_feedback'
    end

    trait :with_number_of_internal_searches do
      number_of_internal_searches 100
      process_name 'number_of_internal_searches'
    end

    sequence(:page_path) { |i| "/path/#{i}" }
    sequence(:date) { |i| i.days.ago.to_date }
  end

  factory :feedex, class: Events::Feedex do
    sequence(:page_path) { |i| "/path/#{i}" }
    sequence(:date) { |i| i.days.ago.to_date }
    feedex_comments 1
  end
end
