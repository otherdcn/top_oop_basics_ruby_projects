require "colorize"

class Board
  attr_accessor :grid, :key

  def initialize
    @grid = Array.new(3) { Array.new(3, ".") }
    @key = [%w[A B C], %w[D E F], %w[G H I]]
  end

  def display_graphic_key
    puts "Use the following key as a guide:\n"
    key.each_with_index do |row, row_idx|
      row.each_with_index do |point, point_idx|
        print "#{point}".ljust(4)

        puts "" if point_idx == 2
      end
    end
    puts "\nWhere would you like to place your mark?"
  end

  def display_grid(marked_point = nil, winning_points = [])
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |point, point_idx|
        if marked_point == [row_idx, point_idx]
          print "#{point}".ljust(4).colorize(:magenta)
        elsif winning_points.include?([row_idx, point_idx])
          print "#{point}".ljust(4).colorize(:green)
        else
          print "#{point}".ljust(4).colorize(:default)
        end
        puts "" if point_idx == 2
      end
    end
  end

  def combined_grids(marked_point = nil, winning_points = [])
    print "\n--- Grid --- ".center(13).underline
    print "--- Key ---".center(13).underline
    puts ""
    grid.each_with_index do |row, row_idx|
      key_row = key[row_idx]
      row.each_with_index do |point, point_idx|
        if marked_point == [row_idx, point_idx]
          print "#{point}".ljust(4).colorize(:magenta)
        elsif winning_points.include?([row_idx, point_idx])
          print "#{point}".ljust(4).colorize(:green)
        else
          print "#{point}".ljust(4).colorize(:default)
        end

        next unless point_idx == 2

        print "|".ljust(5)

        key_row.each { |kdp| print kdp.ljust(4)}

        puts "" if point_idx == 2
      end
    end
  end

  def mark(player_board_mark, coord_id)
    coord = nil # grid point to be marked on board; for highlighting

    key.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        next unless col == coord_id.upcase
        coord = [row_idx, col_idx]
        @grid[row_idx][col_idx] = player_board_mark
        break if coord
      end

      break if coord
    end

    coord
  end

  def row_check(board_mark)
    set_completed = false
    winning_coords = 0

    grid.each_with_index do |row, row_idx|
      if row[0] == board_mark && row[1] == board_mark && row[2] == board_mark
        set_completed = true
        winning_coords = [[row_idx, 0], [row_idx, 1], [row_idx, 2]]
      end
    end

    { set_completed: set_completed, winning_coords: winning_coords }
  end

  def column_check(board_mark)
    grid_flatten = grid.flatten # flatten grid to ease the checking of one columnar points at once
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
    grid_flatten = grid.flatten # flatten grid to ease the checking of one diagonal points at once
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
end

