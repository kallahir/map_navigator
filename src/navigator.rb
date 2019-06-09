require 'pp'
require 'colorize'
require_relative 'keyboard'

class Navigator
  attr_accessor :map, :position, :x_offset, :y_offset

  def initialize
    @position = Point.new({:x => 0, :y => 0})
    @map = [[Point::CURRENT]]
    @x_offset = 0
    @y_offset = 0
  end

  def exec
    while true
      system('clear')
      show_map
      cmd = read_keyboard
      move(cmd)
    end
  end

  private

  def move(cmd)
    case cmd
    when :up
      destination = Point.new({:x => @position.x - 1, :y => @position.y})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y - @y_offset] = Point::VISITED
      @map[destination.x - @x_offset][destination.y - @y_offset] = Point::CURRENT

      @position = destination
    when :right
      destination = Point.new({:x => @position.x, :y => @position.y + 1})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y - @y_offset] = Point::VISITED
      @map[destination.x - @x_offset][destination.y - @y_offset] = Point::CURRENT

      @position = destination
    when :down
      destination = Point.new({:x => @position.x + 1, :y => @position.y})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y - @y_offset] = Point::VISITED
      @map[destination.x - @x_offset][destination.y - @y_offset] = Point::CURRENT

      @position = destination
    when :left
      destination = Point.new({:x => @position.x, :y => @position.y - 1})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y - @y_offset] = Point::VISITED
      @map[destination.x - @x_offset][destination.y - @y_offset] = Point::CURRENT

      @position = destination
    end
  end

  def expand_map(cmd, destination)
    case cmd
    when :up
      return if destination.x > 0
      return if destination.x >= @x_offset

      @map.unshift([Point::UNKNOWN] * @map.first.size)
      @x_offset -= 1
    when :right
      return if destination.y < 0
      return if destination.y < @map.first.size + @y_offset

      @map.each do |line|
        line << Point::UNKNOWN
      end
    when :down
      return if destination.x < 0
      return if destination.x < @map.size + @x_offset

      @map << [Point::UNKNOWN] * @map.first.size
    when :left
      return if destination.y > 0
      return if destination.y >= @y_offset

      @map.each do |line|
        line.unshift(Point::UNKNOWN)
      end
      @y_offset -= 1
      return
    end
  end

  def show_map
    puts "Current Position => x: #{@position.x} | y: #{@position.y}"
    puts '  x'
    print 'y  '
    (0...@map.first.size).each do |y|
      print '%3d' % [y + @y_offset]
    end
    puts
    @map.each_with_index do |line, x|
      print '%3d ' % [x + @x_offset]
      line.each_with_index do |pos, y|
        if ((x + @x_offset) == 0 && (y + @y_offset) == 0) && pos != Point::CURRENT
          print " X ".on_yellow.black
        else
          print " o ".on_blue.white if pos == Point::UNKNOWN
          print " o ".on_green.white if pos == Point::VISITED
          print " o ".on_red.white if pos == Point::CURRENT
        end
      end
      puts
    end
  end

  def read_keyboard
    key = Keyboard.read_char

    case key
    when "\e[A"
      return :up
    when "\e[B"
      return :down
    when "\e[C"
      return :right
    when "\e[D"
      return :left
    when "\r"
      return :enter
    when "\u0003"
      exit 0
    end
  end
end

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

navigator = Navigator.new
navigator.exec

