class Board
  attr_accessor :code
  attr_writer :guess_grid, :feedback_grid

  def initialize(turns = 12, code_length = 5)
    @code = Array.new(code_length, nil)
    @guess_grid = Array.new(turns) { Array.new(code_length, ".") }
    @feedback_grid = Array.new(turns) { Array.new(code_length, ".") }
  end

  def display_guess_grid
    puts "Code-breaker Grid"
    guess_grid.each_with_index do |row_data, row_idx|
      print "#{row_idx + 1}     "
      row_data.each_with_index do |column_data, column_idx|
        print "#{column_data}   "
        puts "" if column_idx == 4
      end
    end
  end

  def display_feedback_grid
    puts "Feedback Grid"
    feedback_grid.each_with_index do |row_data, row_idx|
      print "#{row_idx + 1}     "
      row_data.each_with_index do |column_data, column_idx|
        print "#{column_data}   "
        puts "" if column_idx == 4
      end
    end
  end
end

test_board = Board.new

test_board.display_guess_grid

test_board.display_feedback_grid
