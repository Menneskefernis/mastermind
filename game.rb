require 'colorize'

class Game
  attr_accessor :guess, :guessed_right
  attr_reader :code
  
  def initialize
    @code = []
    @guessed_right = false
    select_random_colors
  end
  
  def start
    puts "Welcome to a game of Mastermind".bold
    
    8.times do
      return if guessed_right
      play_round
    end

    lose_game
  end

  def play_round
    puts ""
    puts "Pick a sequence of four digits from 1-6!".bold

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

  def select_random_colors
    4.times do
      random_number = rand(1..6)
      code.push(random_number)
    end
  end
end

game = Game.new
puts game.code.join('')
game.start