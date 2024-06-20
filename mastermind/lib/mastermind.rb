require_relative "board"
require_relative "player"
require "colorize"

module MasterMind
  class Game
    attr_reader :board, :player_one, :player_two, :code_maker, :code_breaker, :colour_code_array

    def initialize(player_one = "", player_two = "")
      @board = Board.new
      @colour_code_array = %w[red green yellow blue magenta cyan white black]

      if player_one.empty? && player_two.empty?
        @player_one = Computer.new
        @player_two = Human.new
        puts "Default players created..."
      else
        @player_one = Computer.new(player_one)
        @player_two = Human.new(player_two)
        puts "Custom players created..."
      end
    end

    def play
      rounds = 2

      rounds.times do |round|
        set_maker_and_breaker(round)
        puts "===> Round: #{round + 1} "
        puts "===> Code maker: #{@code_maker.name}"
        puts "===> Code breaker: #{@code_breaker.name}"
        match = false

        make_code
        board.guess_grid.size.times do |turn|
          puts "******************** Turn #{turn + 1} ********************".black.on_white
          board.display_guess_grid
          board.display_feedback_grid
          break_code(turn)
          match = provide_feedback(turn)
          next unless match

          end_round(match, turn)
          break
        end
        end_round(false, board.guess_grid.size) unless match
        break if continue_to_next_round == "n"
      end
    end

    private

    def end_round(match = false, turn = 0)
      board.display_guess_grid
      board.display_feedback_grid
      puts "Code: #{board.code}"
      puts "Break: #{board.guess_grid[turn]}"
      if match
        puts "#{code_breaker.name} has broken the code!".colorize(:green)
      else
        puts "#{code_breaker.name} failed to break the code!".colorize(:red)
      end
    end

    def display_colour_code_array_key
      puts "Colour code options:"
      colour_code_array.each_with_index do |colour, idx|
        puts "#{idx + 1}. #{colour}" # add 1 to idx for display list to start from 1 instead of 0
      end
    end

    def set_maker_and_breaker(round)
      if round.even?
        @code_maker = player_one
        @code_breaker = player_two
      else
        @code_maker = player_two
        @code_breaker = player_one
      end
    end

    def make_code
      if code_maker.instance_of?(Human)
        puts "#{code_maker.name}, make the code: "

        input_array = prompt_user_input

        input_array.each_with_index do |element, idx|
          board.code[idx] = colour_code_array[element.to_i]
        end
      else
        puts "#{code_maker.name}, will set a code"
        board.code.each_index do |idx|
          board.code[idx] = colour_code_array[rand(7)]
        end
      end

      puts "Code has been made. Time to break it!"
    end

    def break_code(turn)
      puts "#{code_breaker.name}, break the code: "

      input_array = prompt_user_input

      input_array.each_with_index do |element, idx|
        board.guess_grid[turn][idx] = colour_code_array[element.to_i]
      end
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

    def prompt_user_input
      display_colour_code_array_key
      puts "Enter the digit that matches the colours you want, seperated by a comma, repeat as many colours as you want."

      input_validity = false

      until input_validity
        # puts "To avoid raising an error; select numbers 1-8, and ensure to seperate with a comma"
        puts "e.g. 2,4,1,3,2"
        input_array = gets.chomp.strip.split(",") # split into array then convert to integers
        input_validity = validate_code_input(input_array)
      end

      input_array.map!(&:to_i)
      input_array.map! { |ele| ele - 1 } # subtract 1 to idx for element to macth array indexing

      input_array
    end

    def provide_feedback(turn)
      puts "#{code_maker.name}, provide feedback: "

      if board.code == board.guess_grid[turn]
        code_broken = false
        board.feedback_grid[turn].each_index { |idx| board.feedback_grid[turn][idx] = "2" }
        return code_broken = true
      end

      board.guess_grid[turn].each_with_index do |peg, idx|
        board.feedback_grid[turn][idx] = if board.code[idx] == board.guess_grid[turn][idx]
                                           "2"
                                         elsif board.code.include?(peg)
                                           "1"
                                         else
                                           "0"
                                         end
        code_broken = true if board.feedback_grid[turn].all?(2)
      end
      code_broken
    end

    def continue_to_next_round
      puts "Pleay next round where roles are reversed? [Y/N]"
      next_round = gets.chomp.strip

      if next_round == "y"
        puts "Continuing to next round..."
      else
        puts "Exiting game..."
      end
      next_round
    end
  end
end

round_one = MasterMind::Game.new
# puts "Player one: #{round_one.player_one.name}"
# puts "Player two: #{round_one.player_two.name}"s

round_one.play
