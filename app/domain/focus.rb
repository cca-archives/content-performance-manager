class Focus
  attr_accessor :word, :suggestion

  def initialize(word, suggestion)
    self.word = word
    self.suggestion = suggestion
  end

  def matches?(content)
    content.downcase.include?(word.downcase)
  end

  def can_fix?
    false
  end

  def focus?
    true
  end

  def to_s
    "#<strong><a href='https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style'>#{word}</a></strong> -> #{suggestion}"
  end
end
