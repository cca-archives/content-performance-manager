class ReplaceWord
  attr_accessor :word, :new_word

  def initialize(word, new_word)
    self.word = word
    self.new_word = new_word
  end

  def matches?(content)
    content.include?(word)
  end

  def can_fix?
    true
  end

  def fixme
    "var $textArea = $(document).find('#edition_body'); $textArea.val($textArea.val().replace('#{word}','#{new_word}'));"
  end

  def to_s
    "Replace <strong>#{word}</strong> with <strong>#{new_word}</strong>"
  end
end