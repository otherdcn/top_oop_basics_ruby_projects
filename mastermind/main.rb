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

puts %q{
Welcome to Mastermind.

There is a code-maker and code-breaker. The code-maker sets a colour
code and the code-breaker tries to break it by guessing within a certain
number of turns. Each turn the code-breaker will get some feedback about
how good the guess was; whether it was exactly correct or just the correct
colour but in the wrong position.

Time to break!
}

puts "\nWould you like to play:"
puts "1. Human vs Human"
puts "2. Human vs Computer"

input_validity = false
until input_validity
  print "Select number [1 or 2]: "
  game_mode_input = gets.chomp.strip.to_i
  input_validity = validate_mode_input(game_mode_input)
end

if game_mode_input == 1
  puts "\nSelected Human vs Human"
  print "Enter Player 1 name: "
  player_one_name = gets.chomp.strip

  print "Enter Player 2 name: "
  player_two_name = gets.chomp.strip

  game = MasterMind::Game.new(game_mode_input, player_one_name, player_two_name)
else
  puts "\nSelected Human vs Computer"
  print "Enter Human player name: "
  player_one_name = gets.chomp.strip

  game = MasterMind::Game.new(game_mode_input, player_one_name)
end

print "\nHi #{player_one_name}, "
puts "how many rounds of game:"
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
