require_relative "lib/mastermind"

def validate_mode_input(input)
  if input.between?(1, 2)
    true
  else
    puts "Wrong input; please type 1 or 2; try again"
  end
end

def validate_rounds_input(input)
  if input.between?(1, 3)
    true
  else
    puts "Wrong input; please type 1, 2, or 3; try again"
  end
end

puts "Would you like to play:"
puts "1. Human vs Human"
puts "2. Human vs Computer"

input_validity = false
until input_validity
  print "Select number [1 or 2]: "
  game_mode_input = gets.chomp.strip.to_i
  input_validity = validate_mode_input(game_mode_input)
end

if game_mode_input == 1
  puts "Human vs Human"
  print "Player 1 name: "
  player_one_name = gets.chomp.strip

  print "Player 2 name: "
  player_two_name = gets.chomp.strip

  game = MasterMind::Game.new(game_mode_input, player_one_name, player_two_name)
else
  puts "Human vs Computer"
  print "Player 1 name: "
  player_one_name = gets.chomp.strip

  game = MasterMind::Game.new(game_mode_input, player_one_name)
end

puts "How many rounds of game:"
puts "1. 2"
puts "2. 4"
puts "3. 6"

input_validity = false
until input_validity
  print "Select number [1-3]: "
  game_rounds_input = gets.chomp.strip.to_i
  input_validity = validate_rounds_input(game_rounds_input)
end

game.play(game_rounds_input * 2)
