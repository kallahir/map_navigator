import sys,tty,termios

class _Getch:
    def __call__(self):
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

class Keyboard:
    UP = "up"
    DOWN = "down"
    LEFT = "left"
    RIGHT = "right"
    ENTER = "enter"
    INVALID = "invalid"

    @staticmethod
    def read():
        while(True):
            key = Keyboard.read_char()
            if key == 3:
                exit(1)
            elif key == 65:
                return Keyboard.UP
            elif key == 66:
                return Keyboard.DOWN
            elif key == 67:
                return Keyboard.RIGHT
            elif key == 68:
                return Keyboard.LEFT
            elif key == 13:
                return Keyboard.ENTER
            elif key == 27 or key == 91:
                continue
            else:
                return Keyboard.INVALID

    @staticmethod
    def read_char():
        input_key = _Getch()
        while(True):
            key = input_key()
            if key != '':
                break
        return ord(key)

