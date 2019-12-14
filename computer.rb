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
    code_guess = []
    code_guess = guessed_numbers.numbers_to_array.shuffle

    4.times do |i|
      unless exact_numbers[i].nil?
        code_guess.insert(i, exact_numbers[i])
        next
      end

      if code_guess[i].nil?
        random_number = rand(1..6)
        code_guess[i] = random_number
      end
    end
    
    puts code_guess.join('')
    puts "Including in next guess: " + guessed_numbers.numbers_to_array.to_s.red unless guessed_numbers.numbers_to_array.empty?
    puts ""
    code_guess
  end

  private
  def initialize
    @guessed_numbers = {}
    @exact_numbers = []
  end
end