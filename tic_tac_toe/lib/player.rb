class Player
  attr_reader :name, :board_mark
  attr_accessor :score

  def initialize(name, board_mark)
    @name = name
    @board_mark = board_mark
    @score = 0
  end
end
