require_relative "board"
require_relative "player"
require "colorize"

module TicTacToe
  class Game
    attr_reader :player_x, :player_o
    attr_accessor :board, :round_winner

    def initialize
      @board = Board.new
      @round_winner = nil
      @player_x = Player.new("Player X", "X")
      @player_o = Player.new("Player O", "O")
    end

    def play(rounds = 1)
      puts "Best of #{rounds}" unless rounds == 1

      rounds.times do |round|
        complete_round(round)
      end

      display_scoreboard(rounds)
    end

    def reset_round_state
      self.round_winner = nil
      self.board = Board.new
    end

    def complete_round(round)
      puts "\n******************** Round #{round + 1} ********************".black.on_white
      reset_round_state

      winning_coords = [] # winning grid points for highlighting
      coord_ids_marked = [] # already marked points in grid

      board.combined_grids # display a combined playing board grid and graphic key, side-by-side

      (board.grid.flatten.size / 2.0).ceil.times do |turn|
        puts "\nTurn #{turn + 1}"
        winning_coords = fill_board_per_turn(coord_ids_marked)
        break if round_winner # no need to continue if winner has been found
      end

      announce_round_winner(winning_coords,round+1) # announce winner of the round and tally the score
    end

    def fill_board_per_turn(coord_ids_marked)
      winning_coords = []

      [player_x, player_o].each do |player|
        break if coord_ids_marked.size == 9

        coord_id = prompt_user_input(player, coord_ids_marked)
        coord_ids_marked << coord_id

        marked_coord = board.mark(player.board_mark, coord_id)
        set_check = check_if_three(player)

        if set_check[:set_completed] # has player completed 3-in-a-row
          self.round_winner = player
          winning_coords = set_check[:winning_coords]
          break # no need to allow other player to play
        end

        board.combined_grids(marked_coord) # display playing board grid with recent marked point
      end

      winning_coords
    end

    def prompt_user_input(player, coord_ids_marked)
      loop do
        print "#{player.name} please enter the letter that matches the point you wish to mark: "
        input = gets.chomp.strip.downcase
        return input if input_valid?(input) && input_available?(input, coord_ids_marked)
      end
    end

    def check_if_three(player)
      if row_check(player.board_mark)[:set_completed]
        row_check(player.board_mark)
      elsif column_check(player.board_mark)[:set_completed]
        column_check(player.board_mark)
      elsif diagonal_check(player.board_mark)[:set_completed]
        diagonal_check(player.board_mark)
      else
        { set_completed: false, winning_coords: [] }
      end
    end

    private

    def input_valid?(input)
      if input.between?("a", "i")
        true
      else
        puts "Input not between A-I/a-i. Try again"
        false
      end
    end

    def input_available?(input, coord_ids_marked)
      if coord_ids_marked.include?(input)
        puts "Point arleady marked. Try again!"
        false
      else
        true
      end
    end

    def row_check(board_mark)
      set_completed = false
      winning_coords = 0

      board.grid.each_with_index do |row, row_idx|
        if row[0] == board_mark && row[1] == board_mark && row[2] == board_mark
          set_completed = true
          winning_coords = [[row_idx, 0], [row_idx, 1], [row_idx, 2]]
        end
      end

      { set_completed: set_completed, winning_coords: winning_coords }
    end

    def column_check(board_mark)
      grid_flatten = board.grid.flatten # flatten grid to ease the checking of one columnar points at once
      set_completed = false
      winning_coords = 0

      for idx in 0..2
        unless grid_flatten[idx] == board_mark && grid_flatten[idx + 3] == board_mark && grid_flatten[idx + 6] == board_mark
          next
        end

        set_completed = true
        winning_coords = [[0, 0], [1, 0], [2, 0]] if idx.zero?
        winning_coords = [[0, 1], [1, 1], [2, 1]] if idx == 1
        winning_coords = [[0, 2], [1, 2], [2, 2]] if idx == 2
      end

      { set_completed: set_completed, winning_coords: winning_coords }
    end

    def diagonal_check(board_mark)
      grid_flatten = board.grid.flatten # flatten grid to ease the checking of one diagonal points at once
      set_completed = false
      winning_coords = 0

      if grid_flatten[0] == board_mark && grid_flatten[4] == board_mark && grid_flatten[8] == board_mark
        set_completed = true
        winning_coords = [[0, 0], [1, 1], [2, 2]]
      elsif grid_flatten[2] == board_mark && grid_flatten[4] == board_mark && grid_flatten[6] == board_mark
        set_completed = true
        winning_coords = [[0, 2], [1, 1], [2, 0]]
      end

      { set_completed: set_completed, winning_coords: winning_coords }
    end

    def announce_round_winner(winning_coords,round)
      puts "\n*** Final board ***"
      board.combined_grids(nil, winning_coords)
      puts "\n*** Final board ***"

      print "\nRound #{round}: "

      if round_winner.nil?
        puts "DRAW!".colorize(:yellow)
      else
        round_winner.score += 1
        puts "#{round_winner.name} wins!".colorize(:green)
      end

      print "\nPress any key to continue...\n"
      gets
    end

    def display_scoreboard(rounds)
      draw_score = (rounds - (player_x.score + player_o.score))

      puts "SCOREBOARD".ljust(45).underline
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
        puts "Level! :-l".colorize(:red)
      end

      print "\nPress any key to continue...\n"
      gets
    end

    private :announce_round_winner, :display_scoreboard
  end
end

