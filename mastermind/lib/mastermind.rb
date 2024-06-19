require_relative "board"
require_relative "player"

module MasterMind
  class Game
    attr_reader :board, :player_one, :player_two

    def initialize(player_one = "", player_two = "")
      @board = Board.new

      if player_one.empty? && player_two.empty?
        @player_one = Computer.new
        @player_two = Human.new
        puts "Default players created..."
      else
        @player_one = Computer.new(player_one)
        @player_two = Human.new(player_two)
        puts "Custom players created..."
      end
    end

    def make_code
      puts "make code"
    end

    def break_code
      puts "break code"
    end

    def provide_feedback
      puts "provide feedback"
    end

    def play
      make_code
      board.display_guess_grid

      puts "Turns: #{board.guess_grid.size}"
      board.guess_grid.size.times do |turn|
        puts "Turn #{turn + 1}"
        break_code
        provide_feedback
      end
    end
  end
end

round_one = MasterMind::Game.new
# puts "Player one: #{round_one.player_one.name}"
# puts "Player two: #{round_one.player_two.name}"

round_two = MasterMind::Game.new("DCN", "Al")
# puts "Player one: #{round_two.player_one.name}"
# puts "Player two: #{round_two.player_two.name}"

round_one.play
