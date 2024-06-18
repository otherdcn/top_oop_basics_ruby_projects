require "colorize"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(3) {Array.new(3,".")}
  end

  def display_graphic_key
    puts "Use the following key as a guide:\n"
    puts "  A   B   C"
    puts "  D   E   F"
    puts "  G   H   I"
    puts "\nWhere would you like to place your mark?"
  end

  def display_grid(marked_point=nil,winning_points=[[nil,nil],[nil,nil],[nil,nil]])
    puts "Colorize: #{marked_point}"
    grid.each_with_index do |row,row_idx|
      row.each_with_index do |point,point_idx|
        if ([row_idx,point_idx] == marked_point)
          print "#{point}   ".colorize(:blue)
        elsif  (winning_points.include?([row_idx,point_idx]))
          print "#{point}   ".colorize(:green)
        else
          print "#{point}   "
        end
        puts "" if point_idx == 2
      end
    end
  end
end
