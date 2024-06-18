require_relative "lib/game"

class TicTacToe
  attr_reader :game
  def initialize
    @game = Game.new
  end

  def play
    @game.play
  end
end

tic_tac_toe = TicTacToe.new
tic_tac_toe.play
