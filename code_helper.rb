module CodeHelper
  def random_code
    code = []
    
    4.times do
      random_number = rand(1..6)
      code.push(random_number)
    end

    code
  end
end