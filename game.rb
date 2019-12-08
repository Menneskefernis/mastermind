require 'colorize'

class Game
  attr_accessor :guess
  attr_reader :code
  
  def initialize
    @code = []
    select_random_colors
  end
  
  def start
    puts "Welcome to a game of Mastermind"
    
    3.times { play_round }
  end

  def play_round
    puts ""
    puts "Pick a sequence of four digits from 1-6!"

    begin
      @guess = gets.chomp.gsub(" ", "")
      raise StandardError.new "Not correct number of digits" unless guess.length == 4
    rescue StandardError=>e
      puts e
      puts "Please enter exactly 4 digits"
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
      
      if digit == guessed_digits[i].to_i
        right_digits[digit] -= 1
        exact_digits += 1
      end
    end

    if right_digits.empty?
      number_of_right_digits = 0
    else
      number_of_right_digits = right_digits.values.reduce { |total, number| total + number }
    end

    puts "#{number_of_right_digits} of your digits are in the code..."
    puts "#{exact_digits} digit(s) is/are exactly right!"
  end

  def select_random_colors
    4.times do
      random_number = rand(5)
      code.push(random_number)
    end
  end
end

game = Game.new
puts game.code.join('')
game.start