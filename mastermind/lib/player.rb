class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Human < Player
  attr_reader :name, :code

  def initialize(name, code = "breaker")
    super(name)
    @code = code
  end
end

class Computer < Player
  attr_reader :name, :code

  def initialize(name, code = "maker")
    super(name)
    @code = code
  end
end

player = Player.new("Ready Player One")
dcn = Human.new("DCN", "maker")
al = Computer.new("Al", "breaker")

[player, dcn, al].each do |element|
  puts "Hi, I'm the #{element.class}, my name is #{element.name}."
  puts "I'm a code-#{element.code}" if element.methods.include?(:code)
  puts ""
end
