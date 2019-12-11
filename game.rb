require 'colorize'
require_relative 'code_helper'
require_relative 'computer'

class String
  def num_string_to_arr
    self.gsub(" ", "").split('').map { |number| number.to_i }
  end
end

class Array
  def random_code
    4.times do
      random_number = rand(1..6)
      self.push(random_number)
    end
  end
end

class Game
  include CodeHelper
  
  attr_accessor :guess, :guessed_right, :computer_guessing
  attr_reader :code, :rounds, :computer
  
  def initialize
    @code = []
    @rounds = 12
    @computer = Computer.new
    @computer_guessing = false
    @guessed_right = false
  end

  def introduce
    puts "Welcome to a game of Mastermind".bold
    puts "Would you like to be 1 or 2:"
    puts "1. guesser of the secret code?"
    puts "2. creator of the secret code?"
  end

  def start
    introduce
    
    play_side = gets.chomp.to_i

    set_secret_code if play_side == 1

    if play_side == 2
      self.computer_guessing = true
      puts "What should the secret code be?"
      @code = get_input
    end
    
    rounds_left = rounds

    rounds.times do
      return if guessed_right
      play_round(rounds_left)
      rounds_left -= 1
    end

    lose_game
  end

  def get_input
    gets.chomp.num_string_to_arr
  end

  def validate_code_input
    return false unless guess
    numbers_out_of_range = guess.any? { |number| number.to_i > 6 || number.to_i < 1}
    
    return false if numbers_out_of_range
    return false unless guess.length == 4
    
    true
    
  end

  def play_round(attempts_left)
    puts ""
    puts "You have #{attempts_left} attempts left."
    puts "Pick a sequence of four digits from 1-6!".bold
    if computer_guessing
      @guess = computer.guess
      #puts guess.join('')
    else
      @guess = get_input

      until validate_code_input
        puts "Please enter exactly 4 digits, each between 1 and 6".red unless validate_code_input
        @guess = get_input
      end
    end

    check_guess
    
  end

  def check_guess
    right_digits = Hash.new(0)
    exact_digits = 0

    code.each_with_index do |digit, i|
      if guess.include?(digit) && !right_digits.key?(digit)
        right_digits[digit] = guess.count(digit)
      end

      if right_digits[digit] > code.count(digit)
        right_digits[digit] = code.count(digit)
      end
      
      if digit == guess[i]
        computer.guessed_numbers[i] = digit
        right_digits[digit] -= 1
        exact_digits += 1
      end
    end

    win_game if exact_digits == 4

    show_feedback(right_digits, exact_digits) unless guessed_right
  end

  def show_feedback(right_digits, exact_digits)
    if right_digits.empty?
      number_of_right_digits = 0
    else
      number_of_right_digits = right_digits.values.reduce { |total, number| total + number }
    end
  
    puts "#{number_of_right_digits} of your digits is/are in the code...".light_blue
    puts "#{exact_digits} digit(s) is/are exactly right!".green
  end

  def win_game
    self.guessed_right = true
    puts ""
    puts "You guessed the right code combination!!!".upcase.green.bold
    puts ""
  end

  def lose_game
    puts ""
    puts "You are out of attempts!".upcase.bold.red
    puts "The code was #{code}"
    puts ""
  end

  def set_secret_code
    code = random_code
    puts @code.join('')
  end
end


game = Game.new
#puts game.code.join('')
game.start


#until [Input is 4 numbers in range 1-6] do
#  get_input
#end