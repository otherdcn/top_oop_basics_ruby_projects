require_relative "board"
require_relative "player"
require "colorize"

module MasterMind
  class Game
    attr_reader :player_one, :player_two, :code_maker, :code_breaker, :colour_code_array, :computer_colour_code_array
    attr_accessor :board, :computer_decoded_positions

    def initialize(mode = 2, player_one = "Joe", player_two = "Ted")
      @colour_code_array = %w[red green yellow blue magenta cyan white black]
      @player_one = Human.new(player_one)

      @player_two = if mode == 1
                      Human.new(player_two)
                    else
                      Computer.new
                    end
    end

    def play(rounds = 2)
      puts "\n#{rounds} rounds to play!"
      puts "#{player_one.name} vs #{player_two.name}"

      rounds.times do |round|
        puts "\n******************** Round #{round + 1} ********************".black.on_white
        set_maker_and_breaker(round)
        puts "===> Round: #{round + 1} "
        puts "===> Code maker: #{@code_maker.name}"
        puts "===> Code breaker: #{@code_breaker.name}"
        self.board = Board.new # Generate new board every new round
        puts "===> Boards Set and ready to go!"
        match = false

        make_code

        board.guess_grid.size.times do |turn|
          puts "\n******************** Turn #{turn + 1} ********************".black.on_white
          board.display_combined_guess_and_feedback_grid
          break_code(turn)
          match = provide_feedback(turn)
          next unless match

          end_round(match, turn)
          break
        end
        end_round(false, board.guess_grid.size - 1) unless match
      end

      announce_winner
    end

    private

    def end_round(match, turn)
      board.display_combined_guess_and_feedback_grid
      puts "\nCode: #{board.code}"

      if match
        puts "Break: #{board.guess_grid[turn]}"
        puts "#{code_breaker.name} has broken the code!".colorize(:green)
      else
        puts "Break: N/A"
        puts "#{code_breaker.name} failed to break the code!".colorize(:red)
      end

      add_code_maker_score(turn)

      puts "SCOREBOARD".center(45).underline
      [player_one, player_two].each do |player|
        print player.name.to_s.ljust(15)
        puts "| #{player.score}"
      end

      print "\nPress any key to continue..."
      gets
    end

    def display_colour_code_array_key
      puts "\nColour code options:"
      colour_code_array.each_with_index do |colour, idx|
        puts "#{idx + 1}. #{colour}" # add 1 to idx for display list to start from 1 instead of 0
      end
    end

    def set_maker_and_breaker(round)
      if round.even? # switch between odd? and even?; to test computer as codemaker or codebreaker
        @code_maker = player_two
        @code_breaker = player_one
      else
        @code_maker = player_one
        @code_breaker = player_two
        # Only if player is a computer, setup the properties/attributes needed to decode human code
        setup_computer_codebreaking_properties if code_breaker.instance_of?(Computer)
      end
    end

    def setup_computer_codebreaking_properties
      @computer_colour_code_array = colour_code_array.dup # duplicate so that modifications don't affect original
      @computer_decoded_positions = Array.new(5)
    end

    def make_code
      if code_maker.instance_of?(Human)
        puts "\n#{code_maker.name}, make the code:"

        input_array = prompt_user_input

        input_array.each_with_index do |element, idx|
          board.code[idx] = colour_code_array[element.to_i]
        end
      else
        puts "#{code_maker.name}, will set a code..."
        board.code.each_index do |idx|
          board.code[idx] = colour_code_array[rand(8)]
        end
      end

      puts "Code has been made. Time to break it!"
    end

    def break_code(turn)
      if code_breaker.instance_of?(Human)
        puts "\n#{code_breaker.name}, break the code:"

        input_array = prompt_user_input

        input_array.each_with_index do |element, idx|
          board.guess_grid[turn][idx] = colour_code_array[element.to_i]
        end
      else
        puts "\n#{code_breaker.name}, will try to break the code..."

        computer_check_feedback(turn - 1) unless turn.zero? # Check previous feedback before attemtping nex codebreak

        computer_decoded_positions.each_with_index do |element, idx|
          board.guess_grid[turn][idx] = if element.nil?
                                          # if position hasn't been decoded, randomly select from colour array
                                          computer_colour_code_array[rand(computer_colour_code_array.size)]
                                        else
                                          # if position has been decoded, pass the element
                                          element
                                        end
        end
      end
    end

    def prompt_user_input
      display_colour_code_array_key
      puts "Enter the digit that matches the colours you want, seperated by a comma, repeat as many colours as you want."

      input_validity = false

      until input_validity
        puts "e.g. 2,4,1,3,2"
        input_array = gets.chomp.strip.split(",") # split into array then convert to integers
        input_validity = validate_code_input(input_array)
      end

      input_array.map!(&:to_i)
      input_array.map! { |ele| ele - 1 } # subtract 1 to idx for element to macth array indexing

      input_array
    end

    def validate_code_input(input_array)
      elements_not_integers = input_array.select { |ele| ele.to_i.zero? }
      elements_out_of_range = input_array.reject { |ele| ele.to_i.between?(1, 8) }
      array_too_small = input_array.size < 5
      array_too_big = input_array.size > 5

      if array_too_small
        puts "Not enough colours chosen: size = #{input_array.size}"
      elsif array_too_big
        puts "Too many colours chosen: size = #{input_array.size}"
      elsif !elements_not_integers.empty? # check if all elements are integers
        puts "Some or all are not integers: #{elements_not_integers}"
      elsif !elements_out_of_range.empty?
        puts "Some or all are out of range: #{elements_out_of_range}"
      else
        true
      end
    end

    def provide_feedback(turn)
      puts "Feedback Generated..."

      if board.code == board.guess_grid[turn]
        code_broken = false
        board.feedback_grid[turn].each_index { |idx| board.feedback_grid[turn][idx] = "2" }
        return code_broken = true
      end

      board.guess_grid[turn].each_with_index do |peg, idx|
        board.feedback_grid[turn][idx] = if board.code[idx] == board.guess_grid[turn][idx]
                                           2
                                         elsif board.code.include?(peg)
                                           1
                                         else
                                           0
                                         end
        code_broken = true if board.feedback_grid[turn].all?(2)
      end
      code_broken
    end

    def computer_check_feedback(turn)
      guess_code = board.guess_grid[turn]
      feedback = board.feedback_grid[turn]

      guess_code.each_with_index do |element, idx|
        if feedback[idx].zero?
          computer_colour_code_array.delete(element) # remove from choice of colours to ensure efficiency
        elsif feedback[idx] == 2
          computer_decoded_positions[idx] = element # remember correctly decoded colour and the position for future use
        end
      end

      puts "Decode: #{computer_decoded_positions}"
    end

    def add_code_maker_score(turn)
      code_maker.score += (turn + 1)
    end

    def announce_winner
      print "\nGame over: "
      if player_one.score > player_two.score
        puts "Congratulations #{player_one.name}".green
      else
        puts "Congratulations #{player_two.name}".green
      end
    end
  end
end

# round_one = MasterMind::Game.new

# round_one.play
