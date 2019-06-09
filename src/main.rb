require_relative 'keyboard'
require_relative 'navigator'

class Main
  def initialize
    @navigator = Navigator.new
  end

  def exec
    while true
      system('clear')
      @navigator.show_map
      @navigator.move(read_keyboard)
    end
  end

  private

  def read_keyboard
    case Keyboard.read_char
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

Main.new.exec
