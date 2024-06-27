require "colorize"

class Board
  attr_reader :grid, :key

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
end
