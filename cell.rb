class Cell
  attr_accessor :coords, :color, :next_color
  def initialize(coordinates, initial_color)
    @coords, @color = coordinates, initial_color
  end
end
