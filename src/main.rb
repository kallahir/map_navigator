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
      @navigator.move(Keyboard.read)
    end
  end
end

Main.new.exec
