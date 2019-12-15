require_relative 'code_helper'
require 'colorize'

class Hash
  def numbers_to_array
    array_from_hash = []

    self.each do |key, value|
      value.times { array_from_hash.push(key) }
    end

    array_from_hash
  end
end

class Computer
  include CodeHelper
  
  attr_accessor :exact_numbers, :guessed_numbers
  
  def guess
    code_guess = exact_numbers.dup

    code_guess = fill_in_right_numbers(code_guess)
    code_guess = fill_in_random_numbers(code_guess)
    give_feedback(code_guess)

    code_guess
  end

  private
  def fill_in_right_numbers(code)

    guessed_numbers_to_fill = guessed_numbers.numbers_to_array
    guessed_numbers_to_fill.shuffle!

    while guessed_numbers_to_fill.size > 0
      
      random_number = rand(0..3)
        
      if code[random_number].nil?
        code[random_number] = guessed_numbers_to_fill[0]
        guessed_numbers_to_fill.shift
      end
    end
    code
  end

  def fill_in_random_numbers(code)
    4.times do |i|
      if code[i].nil?
        random_number = rand(1..6)
        code[i] = random_number
      end
    end
    code
  end

  def give_feedback(code)
    puts code.join('')
    puts "Right numbers included (not correct placement) from last guess: " + guessed_numbers.numbers_to_array.to_s.red unless guessed_numbers.numbers_to_array.empty?
    puts ""
  end

  def initialize
    @guessed_numbers = {}
    @exact_numbers = []
  end
end