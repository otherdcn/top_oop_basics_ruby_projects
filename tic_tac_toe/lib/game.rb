require_relative "board"
require_relative "player"

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
    board.display_graphic_key

    (board.grid.flatten.size / 2.0).ceil.times do |round|
      puts "Round #{round+1}"

      [player_x,player_o].each do |player|
        break if points_marked.size == 9
        board.display_grid
        correct_input = false

        until correct_input
          puts "#{player.name} please enter the letter that matches the point you wish to mark: "
          input = gets.chomp.strip.downcase
          validity = check_input_validity(input,points_marked)
          next unless validity
          availability = check_input_availability(input,points_marked)

          correct_input = true if validity && availability
        end
        mark_board(player,input)
        complete_set = check_if_three(player)

        if complete_set
          winner = player.name
          break
        end
      end
      break if winner
    end

    announce_winner(winner)
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
    case position
    when "A","a"
      board.grid[0][0] = player.board_mark
    when "B","b"
      board.grid[0][1] = player.board_mark
    when "C","c"
      board.grid[0][2] = player.board_mark
    when "D","d"
      board.grid[1][0] = player.board_mark
    when "E","e"
      board.grid[1][1] = player.board_mark
    when "F","f"
      board.grid[1][2] = player.board_mark
    when "G","g"
      board.grid[2][0] = player.board_mark
    when "H","h"
      board.grid[2][1] = player.board_mark
    when "I","i"
      board.grid[2][2] = player.board_mark
    else
      puts "Error: unkown point entered!!!"
    end
  end

  def check_if_three(player)
    row_check(player.board_mark) || column_check(player.board_mark) || diagonal_check(player.board_mark)
  end

  def row_check(board_mark)
    row_completed = false
    board.grid.each do |row|
      row_completed = true if (row[0]==board_mark && row[1]==board_mark && row[2]==board_mark)
    end

    row_completed
  end

  def column_check(board_mark)
    grid_flatten = board.grid.flatten
    column_completed = false

    for idx in 0..2
      if grid_flatten[idx]==board_mark && grid_flatten[idx+3]==board_mark && grid_flatten[idx+6]==board_mark
        column_completed = true
      end
    end

    column_completed
  end

  def diagonal_check(board_mark)
    grid_flatten = board.grid.flatten
    diagonal_completed = false

    if grid_flatten[0]==board_mark && grid_flatten[4]==board_mark && grid_flatten[8]==board_mark
      diagonal_completed = true
    elsif grid_flatten[2]==board_mark && grid_flatten[4]==board_mark && grid_flatten[6]==board_mark
      diagonal_completed = true
    end

    diagonal_completed
  end

  def announce_winner(winner)
    puts "*** Final board ***"
    board.display_grid
    puts "*** Final board ***"

    winner ||= "Draw"

    if winner == "Draw"
      puts "DRAW!"
    else
      puts "CONGRATULATIONS: #{winner} WINS!"
    end
  end

end
