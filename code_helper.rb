module CodeHelper
  def random_code
    code = []
    
    4.times do
      random_number = rand(1..6)
      code.push(random_number)
    end

    code
  end

  def place_randomly(array)
    new_array = []
    numbers_to_randomize_from = [0, 1, 2]
      
    array.each do |element|
      random_number = numbers_to_randomize_from.sample
      
      if new_array[random_number].nil?
        new_array[random_number] = element
        numbers_to_randomize_from.delete_at(random_number)
      end
    end
    new_array
  end
end