class Game
  attr_reader :score, :high_score, :rows_cleared, :level, :game_over
  attr_accessor :paused

  def initialize
    @score = 0
    @level = 0
    @rows_cleared = 0
    @game_over = false
    @scoring_list = [40, 100, 300, 1200]
    @paused = false

    high_score_file = File.open('./resources/high_score.txt')
    @high_score = high_score_file.read.to_i
    high_score_file.close
  end

  def game_over=(game_over)
    @game_over = game_over

    if game_over and @score > @high_score
      File.write('./resources/high_score.txt', @score)
    end
  end

  def update_score(rows_cleared)
    if rows_cleared > 0
      if rows_cleared <= @scoring_list.length
        @score += (@level + 1) * @scoring_list[rows_cleared - 1]
      else
        @score + (@level + 1) * (1500 + 1000 * (rows_cleared - @scoring_list.length))
      end
    end

    @rows_cleared += rows_cleared
    @level = (@rows_cleared / 10).to_i
  end
end