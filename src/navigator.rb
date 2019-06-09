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
      pp @position
      pp @x_offset
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

      @map[@position.x - @x_offset][@position.y] = Point::VISITED
      @map[destination.x - @x_offset][destination.y] = Point::CURRENT

      @position = destination
    when :right
      destination = Point.new({:x => @position.x, :y => @position.y + 1})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y] = Point::VISITED
      @map[destination.x - @x_offset][destination.y] = Point::CURRENT

      @position = destination
    when :down
      destination = Point.new({:x => @position.x + 1, :y => @position.y})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y] = Point::VISITED
      @map[destination.x - @x_offset][destination.y] = Point::CURRENT

      @position = destination
    when :left
      destination = Point.new({:x => @position.x, :y => @position.y - 1})
      expand_map(cmd, destination)

      @map[@position.x - @x_offset][@position.y] = Point::VISITED
      @map[destination.x - @x_offset][destination.y] = Point::CURRENT

      @position = destination
    end
  end

  def expand_map(cmd, destination)
    case cmd
    when :up
      if destination.x <= 0
        return if destination.x >= @x_offset
      else
        return
      end
      @map.unshift([Point::UNKNOWN] * @map.first.size)
      @x_offset -= 1
    when :right
      return if @map.first.size > destination.y + @y_offset
      @map.each do |line|
        line << Point::UNKNOWN
      end
    when :down
      if destination.x >= 0
        return if destination.x < @map.size + @x_offset
      else
        return
      end

      @map << [Point::UNKNOWN] * @map.first.size
    when :left
      # @y_offset -= 1
      return
    end
  end

  def show_map
    print '   '
    (0...@map.first.size).each do |y|
      print '%3d' % [y + @y_offset]
    end
    puts
    @map.each_with_index do |line, x|
      print '%3d ' % [x + @x_offset]
      line.each_with_index do |pos, y|
        # TODO: add different character for 0,0
        print " o ".on_blue.white if pos == Point::UNKNOWN
        print " o ".on_green.white if pos == Point::VISITED
        print " o ".on_red.white if pos == Point::CURRENT
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

