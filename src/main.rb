require 'pp'
require 'colorize'
require 'io/console'

class Main
  class InvalidMove < StandardError; end

  attr_reader :curr, :map, :position_map

  def initialize
    @curr = Position.new
    @map = [[Position::CURRENT]]
    @position_map = [[@curr]]
  end

  def exec
    system('clear')
    print_map
    pp @curr.point
    while true
      cmd = read_keyboard
      begin
        if cmd == :enter
          pos = read_keyboard
          show_neighbor(pos)
          sleep 5
        end
        move(cmd)
        system('clear')
        print_map
        pp @curr.point
      rescue InvalidMove => error
        pp error.message
      end
    end
  end

  private

  def show_neighbor(cmd)
    case cmd
    when :up
      pp @curr.up.point
    when :down
      pp @curr.down.point
    when :right
      pp @curr.right.point
    when :left
      pp @curr.left.point
    end
  end

  def move(cmd)
    case cmd
    when :up
      if @curr.up
        new_point = Point.new({:x => @curr.point.x, :y => @curr.point.y - 1})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        @curr = @curr.up
      elsif @curr.up == Position::UNKNOWN
        # expand_map(@map)
        expand_map(@position_map)
        
        new_point = Point.new({:x => @curr.point.x, :y => @curr.point.y - 1})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        new_curr = Position.new({
          :up    => @position_map[new_point.y - 1][new_point.x],
          :down  => @position_map[new_point.y + 1][new_point.x],
          :right => @position_map[new_point.y][new_point.x + 1],
          :left  => @position_map[new_point.y][new_point.x - 1],
          :point => new_point
        })
        @position_map[new_point.y][new_point.x] = new_curr
        @curr = new_curr
      elsif @curr.up == Position::BARRIER
        raise InvalidMove.new('CAN\'T MOVE UP!')
      end
    when :down
      if @curr.down
        new_point = Point.new({:x => @curr.point.x, :y => @curr.point.y + 1})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        @curr = @curr.down
      elsif @curr.down == Position::UNKNOWN
        # expand_map(@map)
        expand_map(@position_map)

        new_point = Point.new({:x => @curr.point.x, :y => @curr.point.y + 1})
        expand_map_dynamic(@map, cmd, new_point)

        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        new_curr = Position.new({
          :up    => @position_map[new_point.y - 1][new_point.x],
          :down  => @position_map[new_point.y + 1][new_point.x],
          :right => @position_map[new_point.y][new_point.x + 1],
          :left  => @position_map[new_point.y][new_point.x - 1],
          :point => new_point
        })
        @position_map[new_point.y][new_point.x] = new_curr
        @curr = new_curr
      elsif @curr.down == Position::BARRIER
        raise InvalidMove.new('CAN\'T MOVE DOWN!')
      end
    when :right
      if @curr.right
        new_point = Point.new({:x => @curr.point.x + 1, :y => @curr.point.y})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        @curr = @curr.right
      elsif @curr.right == Position::UNKNOWN
        # expand_map(@map)
        expand_map(@position_map)

        new_point = Point.new({:x => @curr.point.x + 1, :y => @curr.point.y})
        expand_map_dynamic(@map, cmd, new_point)

        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        new_curr = Position.new({
          :up    => @position_map[new_point.y - 1][new_point.x],
          :down  => @position_map[new_point.y + 1][new_point.x],
          :right => @position_map[new_point.y][new_point.x + 1],
          :left  => @position_map[new_point.y][new_point.x - 1],
          :point => new_point
        })
        @position_map[new_point.y][new_point.x] = new_curr
        @curr = new_curr
      elsif @curr.right == Position::BARRIER
        raise InvalidMove.new('CAN\'T MOVE RIGHT!')
      end
    when :left
      if @curr.left
        new_point = Point.new({:x => @curr.point.x - 1, :y => @curr.point.y})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        @curr = @curr.left
      elsif @curr.left == Position::UNKNOWN
        # expand_map(@map)
        expand_map(@position_map)

        new_point = Point.new({:x => @curr.point.x - 1, :y => @curr.point.y})
        @map[@curr.point.y][@curr.point.x] = Position::VISITED
        @map[new_point.y][new_point.x] = Position::CURRENT

        new_curr = Position.new({
          :up    => @position_map[new_point.y - 1][new_point.x],
          :down  => @position_map[new_point.y + 1][new_point.x],
          :right => @position_map[new_point.y][new_point.x + 1],
          :left  => @position_map[new_point.y][new_point.x - 1],
          :point => new_point
        })
        @position_map[new_point.y][new_point.x] = new_curr
        @curr = new_curr
      elsif @curr.left == Position::BARRIER
        raise InvalidMove.new('CAN\'T MOVE RIGHT!')
      end
    end
  end

  def expand_map(map)
    map.each do |line|
      line << Position::UNKNOWN
    end
    map << [Position::UNKNOWN] * map.first.size
  end

  def expand_map_dynamic(map, direction, destination)
    return unless direction && destination

    case direction
    when :right
      return if map.first.size > destination.x
      map.each do |line|
        line << Position::UNKNOWN
      end
    when :down
      return if map.size > destination.y
      map << [Position::UNKNOWN] * map.first.size
    end
  end

  def print_map
    print '   '
    (0...@map.first.size).each do |j|
      print '%3d' % [j]
    end
    puts
    @map.each_with_index do |line, i|
      print '%3d ' % [i]
      line.each do |pos|
        print " o ".on_blue.white if pos == Position::UNKNOWN
        print " o ".on_green.white if pos == Position::VISITED 
        print " o ".on_red.white if pos == Position::CURRENT
      end
      puts
    end
  end

  def print_location_map
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

class Position
  attr_accessor :up, :down, :left, :right, :point

  UNKNOWN = nil
  BARRIER = -1 
  VISITED = 1
  CURRENT = 'X'

  def initialize(args = nil)
    if args.nil?
      starting_point
    else
      @up    = args[:up]
      @down  = args[:down]
      @right = args[:right]
      @left  = args[:left]
      @point = args[:point] 
    end
  end

  private

  def starting_point
    @right = UNKNOWN
    @down  = UNKNOWN 
    @point = Point.new({:x => 0, :y => 0})
  end
end

class Point
  attr_accessor :x, :y

  def initialize(args)
    @x = args[:x]
    @y = args[:y]
  end
end

class Keyboard
  def self.read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end

main = Main.new
main.exec

