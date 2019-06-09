class Point
  UNKNOWN = nil
  CURRENT = 0
  VISITED = 1
  BARRIER = -1

  attr_accessor :x, :y

  def initialize(args)
    @x = args[:x]
    @y = args[:y]
  end
end
