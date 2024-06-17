class TicTacToe
  attr_reader :board, :player_x, :player_o

  def initialize(player_x="Player X",player_o="Player O")
    @player_x = {name: player_x, board_mark: "X"}
    @player_o = {name: player_o, board_mark: "O"}

    @board = Array.new(3) {Array.new(3,".")}
  end

  def play
    found_winner = false
    display_graphic_key
    points_marked = []

    (board.flatten.size / 2.0).ceil.times do |round|
      puts "Round #{round}"

      [player_x,player_o].each do |player|
        break if points_marked.size == 9
        display_board
        correct_input = false

        until correct_input
          puts "#{player[:name]} please enter the letter that matches the point you wish to mark: "
          input = gets.chomp.strip.downcase
          result = check_input(input,points_marked)

          if result[:continue]
            correct_input = result[:continue]
          else
            puts result[:error_msg]
          end
        end
        mark_board(player,input)
        # binding.break
        complete = check_if_three(player)

        if complete
          found_winner = player[:name]
          break
        end
      end
      break if found_winner
    end
    puts "*** Final board ***"
    display_board
    puts "*** Final board ***"

    found_winner ||= "Draw"

    if found_winner == "Draw"
      puts "DRAW!"
    else
      puts "CONGRATULATIONS: #{found_winner}!"
    end
  end

  private
  def display_graphic_key
    puts "Use the following key as a guide:\n"
    puts "  A   B   C"
    puts "  D   E   F"
    puts "  G   H   I"
    puts "\nWhere would you like to place your mark?"
  end

  def display_board
    board.each do |row|
      row.each_with_index do |point,idx|
        print "#{point}    "
        puts "" if idx == 2
      end
    end
  end

  def check_input(input,points_marked)
    continue = false
    error_msg = ""

    if input.between?("a","i")
      continue = true
    else
      error_msg = "Input not between A-I/a-i. Try again"
    end

    if points_marked.include?(input)
      error_msg = "Point arleady marked. Try again!"
      continue = false
    else
      points_marked << input
      continue = true
    end

    {continue: continue,error_msg: error_msg}
  end

  def mark_board(player,position)
    case position
    when "A","a"
      board[0][0] = player[:board_mark]
    when "B","b"
      board[0][1] = player[:board_mark]
    when "C","c"
      board[0][2] = player[:board_mark]
    when "D","d"
      board[1][0] = player[:board_mark]
    when "E","e"
      board[1][1] = player[:board_mark]
    when "F","f"
      board[1][2] = player[:board_mark]
    when "G","g"
      board[2][0] = player[:board_mark]
    when "H","h"
      board[2][1] = player[:board_mark]
    when "I","i"
      board[2][2] = player[:board_mark]
    else
      puts "Error: unkown point entered!!!"
    end
  end

  def check_if_three(player)
    row_check(player[:board_mark]) || column_check(player[:board_mark]) || diagonal_check(player[:board_mark])
  end

  def row_check(mark)
    row_completed = false
    board.each do |row|
      row_completed = true if (row[0]==mark && row[1]==mark && row[2]==mark)
    end

    row_completed
  end

  def column_check(mark)
    board_flatten = board.flatten
    column_completed = false

    for idx in 0..2
      if board_flatten[idx]==mark && board_flatten[idx+3]==mark && board_flatten[idx+6]==mark
        column_completed = true
      end
    end

    column_completed
  end

  def diagonal_check(mark)
    board_flatten = board.flatten
    diagonal_completed = false

    if board_flatten[0]==mark && board_flatten[4]==mark && board_flatten[8]==mark
      diagonal_completed = true
    elsif board_flatten[2]==mark && board_flatten[4]==mark && board_flatten[6]==mark
      diagonal_completed = true
    end

    diagonal_completed
  end

end

# binding.break
tic_tac_toe = TicTacToe.new
tic_tac_toe.play
