require "colorize"

class Board
  attr_accessor :code, :guess_grid, :feedback_grid

  def initialize(turns = 12, code_length = 5)
    @code = Array.new(code_length)
    @guess_grid = Array.new(turns) { Array.new(code_length, ".") }
    @feedback_grid = Array.new(turns) { Array.new(code_length, ".") }
  end

  def display_guess_grid
    puts "Code-breaker Grid".underline

    formatted_guess_grid = guess_grid.map do |row|
      row.map do |col|
        col.ljust(8)
      end
    end

    formatted_guess_grid.each_with_index do |row_data, row_idx|
      row_idx += 1
      print row_idx.to_s.ljust(4)
      row_data.each_with_index do |column_data, column_idx|
        print column_data
        puts "" if column_idx == 4
      end
    end
  end

  def display_feedback_grid
    puts "Feedback key:".underline
    puts "0 (colour not present)"
    puts "1 (colour present, wrong position)"
    puts "2 (colour present, right position)"

    puts "Feedback Grid".underline

    formatted_feedback_grid = feedback_grid.map do |row|
      row.map do |col|
        col.to_s.ljust(8)
      end
    end

    formatted_feedback_grid.each_with_index do |row_data, row_idx|
      row_idx += 1
      print row_idx.to_s.ljust(4)
      row_data.each_with_index do |column_data, column_idx|
        print column_data
        puts "" if column_idx == 4
      end
    end
  end

  # Combined display for the breaker to see progress
  def display_combined_guess_and_feedback_grid
    formatted_feedback_grid = feedback_grid.map do |row|
      row.map { |col| col.to_s.ljust(8) }
    end

    formatted_guess_grid = guess_grid.map do |row|
      row.map { |col| col.ljust(8) }
    end

    puts "0 (colour not present)"
    puts "1 (colour present, wrong position)"
    puts "2 (colour present, right position)\n\n"

    print "--- Guess Grid --- ".center(41).underline
    print "--- Feedback Grid ---".center(41).underline
    puts ""
    formatted_guess_grid.each_with_index do |row_data, row_idx|
      feedback_row = formatted_feedback_grid[row_idx]
      row_idx += 1

      print row_idx.to_s.ljust(4)
      row_data.each_with_index do |column_data, column_idx|
        print column_data
        next unless column_idx == 4

        print "|".ljust(5)

        feedback_row.each do |fdp|
          print fdp
        end

        puts ""
      end
    end
  end
end

# test_board = Board.new

# test_board.display_guess_grid

# test_board.display_feedback_grid

# test_board.display_combined_guess_and_feedback_grid
