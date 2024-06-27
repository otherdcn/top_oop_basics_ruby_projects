require_relative "board"
require_relative "player"
require "colorize"

module TicTacToe
  class Game
    attr_reader :player_x, :player_o
    attr_accessor :board, :round_winner

    def initialize
      @board = Board.new
      @player_x = Player.new("Player X", "X")
      @player_o = Player.new("Player O", "O")
    end

    def play(rounds = 1)
      puts "Best of #{rounds}" unless rounds == 1

      rounds.times do |round|
        puts "\n******************** Round #{round + 1} ********************".black.on_white

        self.round_winner = nil # winner of round
        self.board = Board.new
        points_marked = [] # already marked points in grid
        winning_points = nil # winning grid points for highlighting

        board.display_graphic_key # display graphic to indicate whice keys to press
        board.display_grid # display playing board grid

        (board.grid.flatten.size / 2.0).ceil.times do |turn|
          puts "Turn #{turn + 1}"

          [player_x, player_o].each do |player|
            break if points_marked.size == 9

            correct_input = false

            until correct_input # sanitise and validate input
              print "#{player.name} please enter the letter that matches the point you wish to mark: "
              input = gets.chomp.strip.downcase
              validity = check_input_validity(input) # ensure input is valid
              next unless validity # skip below if invalid input is received and try agin

              availability = check_input_availability(input, points_marked) # ensure input is not already marked

              correct_input = true if validity && availability
            end

            marked_point = mark_board(player, input)
            set_check = check_if_three(player)
            set_completed = set_check[:set_completed]
            winning_points = set_check[:winning_points]

            if set_completed # has player completed 3-in-a-row
              self.round_winner = player
              break # no need to allow other player to play
            end

            board.display_grid(marked_point) # display playing board grid with recent marked point
          end
          break if self.round_winner # no need to continue if winner has been found
        end
        announce_round_winner(winning_points,round+1) # announce winner of the round and tally the score
      end

      display_scoreboard(rounds)
    end

    private

    def check_input_validity(input)
      continue = false

      if input.between?("a", "i")
        continue = true
      else
        puts "Input not between A-I/a-i. Try again"
        continue = false
      end

      continue
    end

    def check_input_availability(input, points_marked)
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

    def mark_board(player, position)
      point = nil # grid point to be marked on board; for highlighting

      case position
      when "A", "a"
        board.grid[0][0] = player.board_mark
        point = [0, 0]
      when "B", "b"
        board.grid[0][1] = player.board_mark
        point = [0, 1]
      when "C", "c"
        board.grid[0][2] = player.board_mark
        point = [0, 2]
      when "D", "d"
        board.grid[1][0] = player.board_mark
        point = [1, 0]
      when "E", "e"
        board.grid[1][1] = player.board_mark
        point = [1, 1]
      when "F", "f"
        board.grid[1][2] = player.board_mark
        point = [1, 2]
      when "G", "g"
        board.grid[2][0] = player.board_mark
        point = [2, 0]
      when "H", "h"
        board.grid[2][1] = player.board_mark
        point = [2, 1]
      when "I", "i"
        board.grid[2][2] = player.board_mark
        point = [2, 2]
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
        { set_completed: false, winning_points: [] }
      end
    end

    def row_check(board_mark)
      set_completed = false
      winning_points = 0

      board.grid.each_with_index do |row, row_idx|
        if row[0] == board_mark && row[1] == board_mark && row[2] == board_mark
          set_completed = true
          winning_points = [[row_idx, 0], [row_idx, 1], [row_idx, 2]]
        end
      end

      { set_completed: set_completed, winning_points: winning_points }
    end

    def column_check(board_mark)
      grid_flatten = board.grid.flatten # flatten grid to ease the checking of one columnar points at once
      set_completed = false
      winning_points = 0

      for idx in 0..2
        unless grid_flatten[idx] == board_mark && grid_flatten[idx + 3] == board_mark && grid_flatten[idx + 6] == board_mark
          next
        end

        set_completed = true
        winning_points = [[0, 0], [1, 0], [2, 0]] if idx.zero?
        winning_points = [[0, 1], [1, 1], [2, 1]] if idx == 1
        winning_points = [[0, 2], [1, 2], [2, 2]] if idx == 2
      end

      { set_completed: set_completed, winning_points: winning_points }
    end

    def diagonal_check(board_mark)
      grid_flatten = board.grid.flatten # flatten grid to ease the checking of one diagonal points at once
      set_completed = false
      winning_points = 0

      if grid_flatten[0] == board_mark && grid_flatten[4] == board_mark && grid_flatten[8] == board_mark
        set_completed = true
        winning_points = [[0, 0], [1, 1], [2, 2]]
      elsif grid_flatten[2] == board_mark && grid_flatten[4] == board_mark && grid_flatten[6] == board_mark
        set_completed = true
        winning_points = [[0, 2], [1, 1], [2, 0]]
      end

      { set_completed: set_completed, winning_points: winning_points }
    end

    def announce_round_winner(winning_points,round)
      puts "*** Final board ***"
      board.display_grid(nil, winning_points)
      puts "*** Final board ***"

      if round_winner.nil?
        puts "DRAW!".colorize(:yellow)
      else
        round_winner.score += 1
        puts "Round #{round} goes to #{round_winner.name}!".colorize(:green)
      end

      print "Press any key to continue..."
      gets
    end

    def display_scoreboard(rounds)
      draw_score = (rounds - (player_x.score + player_o.score))

      puts "SCOREBOARD".center(45).underline
      [player_x, player_o].each do |player|
        print player.name.to_s.ljust(15)
        puts "| #{player.score}"
      end
      print "Draw".ljust(15)
      puts "| #{draw_score}"

      if player_x.score > player_o.score
        puts "#{player_x.name} wins Best of #{rounds}!".colorize(:green)
      elsif player_x.score < player_o.score
        puts "#{player_o.name} wins Best of #{rounds}!".colorize(:green)
      else
        puts "Level! :-(".colorize(:red)
      end

      print "Press any key to continue..."
      gets
    end
  end
end
