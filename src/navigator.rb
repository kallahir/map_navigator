require 'colorize'
require_relative 'point'

class Navigator
  attr_reader :map, :position, :x_offset, :y_offset

  def initialize
    @position = Point.new({:x => 0, :y => 0})
    @map = [[Point::CURRENT]]
    @x_offset = 0
    @y_offset = 0
  end

  def move(cmd)
    case cmd
    when :up
      execute_movement(cmd: cmd, x_modifier: -1)
    when :right
      execute_movement(cmd: cmd, y_modifier: 1)
    when :down
      execute_movement(cmd: cmd, x_modifier: 1)
    when :left
      execute_movement(cmd: cmd, y_modifier: -1)
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
          print "<^>".on_red.white if pos == Point::CURRENT
        end
      end
      puts
    end
  end

  private

  def execute_movement(cmd:, x_modifier: 0, y_modifier: 0)
    destination = Point.new({:x => @position.x + x_modifier, :y => @position.y + y_modifier})
    expand_map(cmd, destination)

    @map[@position.x - @x_offset][@position.y - @y_offset] = Point::VISITED
    @map[destination.x - @x_offset][destination.y - @y_offset] = Point::CURRENT

    @position = destination
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
    end
  end
end
