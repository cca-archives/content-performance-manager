require 'html_to_plain_text'
require 'redcarpet'
require 'redcarpet/render_strip'

module Metrics
  class Importer

    def self.call(content_ids: [])
      Content::Item.where(content_id: content_ids).find_each do |content_item|

        metrics.each do
          metrics.each do |code, value|
            Metric.create_with(value: value).find_or_create_by(content_id: content_id, day: day, code: code)
          end
        end
      end
    end

    def self.do_calculate_metrics()
      base_paths.each do |base_path|
        item = Content::Item.find_by(base_path: base_path)
        if item
          begin
            published = Content::ItemsService.new.fetch(item.content_id, 'en')
            latest_version = published[:user_facing_version]
            (1..latest_version).to_a.each do |version|
              result = Content::ItemsService.new.fetch_attributes(item.content_id, 'en', version)
              puts "Calculating version: #{version}"
              p result[:updated_at]
              # p result[:title].length
              # p result[:description].length
              content = result[:description]
              metrics_for(content)
              # parts.each do |part|
              #   content = part[:body][0][:content]
              # end
            end
          rescue => e
            puts "Error #{e.message}"
          end
        end
      end
    end

    def self.calculate_reading_time(content)
      values = content.reading_time(:format => :raw)
      values[0] * 60 + values[1] * 60 + values[2]
    end

    def self.metrics_for(markdown)
      # p markdown
      # html = Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(markdown)
      content = HtmlToPlainText.plain_text(markdown)
      # p content
      # p content.length
      stats = Odyssey.flesch_kincaid_re(content, true).with_indifferent_access
      # p calculate_reading_time(content)
      # puts (
        {
          reading_time: calculate_reading_time(content),
          string_length: stats.fetch(:string_length),
          letter_count: stats.fetch(:letter_count),
          syllable_count: stats.fetch(:syllable_count),
          word_count: stats.fetch(:word_count),
          sentence_count: stats.fetch(:sentence_count),
          average_words_per_sentence: stats.fetch(:average_words_per_sentence),
          average_syllables_per_word: stats.fetch(:average_syllables_per_word),
          score: stats.fetch(:score),
          # warnings: rules.run(content).length,
          # title_length: item.title.length,
          # description_length: item.description.length,
        }
      # )
    end

    def self.base_paths
      # Content::Item.where(publishing_app: "publisher").limit(10000).pluck(:base_path)
      @paths ||= [
        '/government/publications/apply-for-a-letter-of-initial-assessment-msf-4352',
        '/government/publications/enterprise-zones-application-form-and-guidance-may-2011',
        '/government/publications/local-growth-fund-housing-revenue-account-borrowing-programme-2015-to-2016-and-2016-to-2017',
        '/government/publications/a-coastal-concordat-for-england',
        '/government/publications/impact-assessment-opinion-prevention-of-air-pollution-from-shipping-implementation-of-directive-201233eu-marine-fuel-sulphur',
        '/government/publications/climate-adaptation-reporting-second-round-maritime-and-coastguard-agency',
        '/government/publications/mou-data-request-form-msf-5369',
        '/government/publications/an-independent-review-of-the-economic-requirement-for-trained-seafarers-in-the-uk',
        '/government/publications/brief-overview-of-the-uk-national-maritime-security-programme',
        '/government/consultations/city-of-liverpool-cruise-terminal-turnaround-operations-consultation-on-proposal-to-withdraw-dft-objection-to-removal-of-a-grant-condition',
        '/government/consultations/consultation-on-on-the-implementation-of-eu-regulation-1177-2010',
        '/government/consultations/consultation-on-the-implementation-of-eu-regulation-ec-392-2009',
        '/government/consultations/consultation-on-the-insurance-of-shipowners-for-maritime-claims',
      ]
    end
  end
end











