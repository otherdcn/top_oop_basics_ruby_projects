require_relative "board"
require_relative "player"
require "colorize"

module TicTacToe
  class Game
    attr_reader :board, :player_x, :player_o

    def initialize()
      @board = Board.new
      @player_x = Player.new("Player X","X")
      @player_o = Player.new("Player O","O")
    end

    def play
      winner = nil
      points_marked = []
      winning_points = nil
      board.display_graphic_key
      board.display_grid

      (board.grid.flatten.size / 2.0).ceil.times do |round|
        puts "Round #{round+1}"

        [player_x,player_o].each do |player|
          break if points_marked.size == 9
          correct_input = false

          until correct_input
            puts "#{player.name} please enter the letter that matches the point you wish to mark: "
            input = gets.chomp.strip.downcase
            validity = check_input_validity(input,points_marked)
            next unless validity
            availability = check_input_availability(input,points_marked)

            correct_input = true if validity && availability
          end
          marked_point = mark_board(player,input)
          check_if_three(player) => {set_completed:, winning_points:}

          if set_completed
            winner = player.name
            break
          end

          board.display_grid(marked_point)
        end
        break if winner
      end

      announce_winner(winner,winning_points)
    end

    private

    def check_input_validity(input,points_marked)
      continue = false

      if input.between?("a","i")
        continue = true
      else
        puts "Input not between A-I/a-i. Try again"
        continue = false
      end

      continue
    end

    def check_input_availability(input,points_marked)
      continue = false

      if points_marked.include?(input)
        puts "Point arleady marked. Try again!"
        continue = false
      else
        points_marked << input
        continue = true
      end

      continue
    end

    def mark_board(player,position)
      point = nil
      case position
      when "A","a"
        board.grid[0][0] = player.board_mark
        point = [0,0]
      when "B","b"
        board.grid[0][1] = player.board_mark
        point = [0,1]
      when "C","c"
        board.grid[0][2] = player.board_mark
        point = [0,2]
      when "D","d"
        board.grid[1][0] = player.board_mark
        point = [1,0]
      when "E","e"
        board.grid[1][1] = player.board_mark
        point = [1,1]
      when "F","f"
        board.grid[1][2] = player.board_mark
        point = [1,2]
      when "G","g"
        board.grid[2][0] = player.board_mark
        point = [2,0]
      when "H","h"
        board.grid[2][1] = player.board_mark
        point = [2,1]
      when "I","i"
        board.grid[2][2] = player.board_mark
        point = [2,2]
      else
        puts "Error: unkown point entered!!!"
      end

      point
    end

    def check_if_three(player)
      if row_check(player.board_mark)[:set_completed]
        row_check(player.board_mark)
      elsif column_check(player.board_mark)[:set_completed]
        column_check(player.board_mark)
      elsif diagonal_check(player.board_mark)[:set_completed]
        diagonal_check(player.board_mark)
      else
        {set_completed: false, winning_points: 0}
      end
    end

    def row_check(board_mark)
      set_completed = false
      winning_points = 0

      board.grid.each_with_index do |row,row_idx|
        if (row[0]==board_mark && row[1]==board_mark && row[2]==board_mark)
          set_completed = true
          winning_points = [[row_idx,0],[row_idx,1],[row_idx,2]]
        end
      end

      {set_completed: set_completed, winning_points: winning_points}
    end

    def column_check(board_mark)
      grid_flatten = board.grid.flatten
      set_completed = false
      winning_points = 0

      for idx in 0..2
        if grid_flatten[idx]==board_mark && grid_flatten[idx+3]==board_mark && grid_flatten[idx+6]==board_mark
          set_completed = true
          winning_points = [[0,0],[1,0],[2,0]] if idx == 0
          winning_points = [[0,1],[1,1],[2,1]] if idx == 1
          winning_points = [[0,2],[1,2],[2,2]] if idx == 2
        end
      end

      {set_completed: set_completed, winning_points: winning_points}
    end

    def diagonal_check(board_mark)
      grid_flatten = board.grid.flatten
      set_completed = false
      winning_points = 0

      if grid_flatten[0]==board_mark && grid_flatten[4]==board_mark && grid_flatten[8]==board_mark
        set_completed = true
        winning_points = [[0,0],[1,1],[2,2]]
      elsif grid_flatten[2]==board_mark && grid_flatten[4]==board_mark && grid_flatten[6]==board_mark
        set_completed = true
        winning_points = [[0,2],[1,1],[2,0]]
      end

      {set_completed: set_completed, winning_points: winning_points}
    end

    def announce_winner(winner,winning_points)
      puts "*** Final board ***"
      board.display_grid(nil,winning_points)
      puts "*** Final board ***"

      winner ||= "Draw"

      if winner == "Draw"
        puts "DRAW!".colorize(:yellow)
      else
        puts "CONGRATULATIONS: #{winner} WINS!".colorize(:green)
      end
    end

  end
end
