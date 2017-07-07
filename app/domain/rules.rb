class Rules
  attr_accessor :rules

  def initialize
    self.rules = []
    self.rules << BannedWordRule.new("agenda")
    self.rules << BannedWordRule.new("advancing")
    self.rules << BannedWordRule.new("collaborate")
    self.rules << BannedWordRule.new("combating")
    self.rules << BannedWordRule.new("commit")
    self.rules << BannedWordRule.new("pledge")
    self.rules << BannedWordRule.new("countering")
    self.rules << BannedWordRule.new("deliver")
    self.rules << BannedWordRule.new("deploy")
    self.rules << BannedWordRule.new("dialogue")
    self.rules << BannedWordRule.new("disincentivise")
    self.rules << BannedWordRule.new("empower")
    self.rules << BannedWordRule.new("facilitate")
    self.rules << BannedWordRule.new("focusing")
    self.rules << BannedWordRule.new("foster")
    self.rules << BannedWordRule.new("impact")
    self.rules << BannedWordRule.new("initiate")
    self.rules << BannedWordRule.new("key")
    self.rules << BannedWordRule.new("land")
    self.rules << BannedWordRule.new("leverage")
    self.rules << BannedWordRule.new("liaise")
    self.rules << BannedWordRule.new("overarching")
    self.rules << BannedWordRule.new("progress")
    self.rules << BannedWordRule.new("promote")
    self.rules << BannedWordRule.new("robust")
    self.rules << BannedWordRule.new("slimming down")
    self.rules << BannedWordRule.new("streamline")
    self.rules << BannedWordRule.new("strengthening")
    self.rules << BannedWordRule.new("tackling")
    self.rules << BannedWordRule.new("transforming")
    self.rules << BannedWordRule.new("utilise")


    self.rules << AvoidMetaphorRule.new("drive")
    self.rules << AvoidMetaphorRule.new("drive out")
    self.rules << AvoidMetaphorRule.new("going forward")
    self.rules << AvoidMetaphorRule.new("in order to")
    self.rules << AvoidMetaphorRule.new("one-stop shop")
    self.rules << AvoidMetaphorRule.new("ring fencing")

    self.rules << ReplaceWord.new("al-Qaeda’", "al-Qa’ida")
    self.rules << ReplaceWord.new("‘al-Qaida", "al-Qa’ida")
    self.rules << ReplaceWord.new("Alternative Provision", "alternative provision")
    self.rules << ReplaceWord.new("Alternative provision", "alternative provision")
    self.rules << ReplaceWord.new("attendance allowance", "Attendance Allowance")
  end

  def run(content)
    self.rules.select do |rule|
      rule.matches?(content)
    end
  end
end
































