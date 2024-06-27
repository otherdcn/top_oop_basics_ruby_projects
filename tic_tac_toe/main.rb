require_relative "lib/tic_tac_toe"

def validate_rounds_input(input)
  if input.between?(1, 3)
    true
  else
    puts "Wrong input; please type 1, 2, or 3; try again"
  end
end

puts "How many rounds of game:"
puts "1. One off"
puts "2. Best of 3"
puts "3. Best of 5"

input_validity = false
until input_validity
  print "Select number [1-3]: "
  game_rounds_input = gets.chomp.strip.to_i
  input_validity = validate_rounds_input(game_rounds_input)
end

rounds = 0
if game_rounds_input == 1
  rounds = 1
elsif game_rounds_input == 2
  rounds = 3
elsif game_rounds_input == 3
  rounds = 5
end

tic_tac_toe = TicTacToe::Game.new
tic_tac_toe.play(rounds)
