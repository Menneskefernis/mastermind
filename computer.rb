require_relative 'code_helper'
require 'colorize'

class Computer
  include CodeHelper
  
  attr_accessor :guessed_numbers, :code_guess
  def initialize
    @code_guess = []
    @guessed_numbers = []
  end
  
  def guess
    puts guessed_numbers.join('').red
    
    self.code_guess = random_code if code_guess.empty?
    
    4.times do |i|
      unless guessed_numbers[i].nil?
        self.code_guess[i] = guessed_numbers[i]
        next
      end
      
      random_number = rand(1..6)
      code_guess[i] = random_number
    end
    code_guess
  end
end