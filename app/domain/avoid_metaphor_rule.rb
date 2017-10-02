class AvoidMetaphorRule
  attr_accessor :word

  def initialize(word)
    self.word = word
  end

  def matches?(content)
    content.downcase.include?(word.downcase)
  end

  def can_fix?
    false
  end

  def focus?
    false
  end

  def to_s
   "The word <strong>#{word}</strong> is a metaphor"
  end
end