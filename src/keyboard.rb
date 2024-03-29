require 'io/console'

class Keyboard
  def self.read
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

  private

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
