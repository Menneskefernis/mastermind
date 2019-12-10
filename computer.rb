require_relative 'code_helper'

class Computer
  include CodeHelper
  def random_guess
    random_code
  end
end