class Result
  attr_accessor :translation, :score, :message, :time

  def average_score(scores, score)
    scores << score.to_i
    scores.inject{ |sum, el| sum + el }.to_f / scores.size
  end

end