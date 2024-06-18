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

  def display_grid
    grid.each do |row|
      row.each_with_index do |point,idx|
        print "#{point}    "
        puts "" if idx == 2
      end
    end
  end
end
