require 'odyssey'
class ContentMetrics

  attr_accessor :content, :reading_time, :string_length, :letter_count,
    :syllable_count, :word_count, :sentence_count, :average_words_per_sentence,
    :average_syllables_per_word, :score, :warnings, :gds_points, :content_item

  def initialize(content: content, content_item: content_item)
    self.content_item = content_item
    self.reading_time = content.reading_time

    stats = Odyssey.flesch_kincaid_re(content, true).with_indifferent_access
    self.string_length = stats.fetch(:string_length)
    self.letter_count = stats.fetch(:letter_count)
    self.syllable_count = stats.fetch(:syllable_count)
    self.word_count = stats.fetch(:word_count)
    self.sentence_count = stats.fetch(:sentence_count)
    self.average_words_per_sentence = stats.fetch(:average_words_per_sentence)
    self.average_syllables_per_word = stats.fetch(:average_syllables_per_word)
    self.score = stats.fetch(:score)

    rules = Rules.new
    self.warnings = rules.run(content)
    self.gds_points = calculate_gds_points
  end

  private

  def calculate_gds_points
    (3 * self.score - (15 * self.warnings.count))
  end
end
