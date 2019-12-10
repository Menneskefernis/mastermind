require 'colorize'
require_relative 'code_helper'

class String
  def num_string_to_arr
    self.split('').map { |number| number.to_i }
  end
end

class Game
  include CodeHelper
  
  attr_accessor :guess, :guessed_right
  attr_reader :code
  
  def initialize
    @code = []
    @guessed_right = false
  end

  def introduce
    puts "Welcome to a game of Mastermind".bold
    puts "Would you like to be 1 or 2:"
    puts "1. creator of the secret code?"
    puts "2. guesser of the secret code?"
  end

  def start
    introduce
    
    play_side = gets.chomp.to_i

    select_random_numbers if play_side == 2

    if play_side == 1
        puts "What should the secret code be?"
        @code = gets.chomp.num_string_to_arr
    end
    
    8.times do
      return if guessed_right
      play_round
    end

    lose_game
  end

  def play_round
    puts ""
    puts "Pick a sequence of four digits from 1-6!".bold

    # maybe some proc stuff here
    begin
      @guess = gets.chomp.gsub(" ", "")
      
      numbers_out_of_range = guess.split('').any? { |number| number.to_i > 6 || number.to_i < 1}
      
      raise StandardError.new "Digit out of range" if numbers_out_of_range
      raise StandardError.new "Not correct number of digits" unless guess.length == 4
    rescue StandardError=>e
      puts ""
      puts e
      puts "Please enter exactly 4 digits, each between 1 and 6"
      retry
    else
      check_guess
    end
  end

  def check_guess
    guessed_digits = guess.split('')
    right_digits = Hash.new(0)
    exact_digits = 0

    code.each_with_index do |digit, i|
      if guess.include?(digit.to_s) && !right_digits.key?(digit)
        right_digits[digit] = guess.count(digit.to_s)
      end

      if right_digits[digit] > code.count(digit)
        right_digits[digit] = code.count(digit)
      end
      
      if digit == guessed_digits[i].to_i
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

  def select_random_numbers
    @code = random_code
    puts @code.join('')
  end
end


game = Game.new
#puts game.code.join('')
game.start