# import curses
#
# # get the curses screen window
# screen = curses.initscr()
#
# # turn off input echoing
# curses.noecho()
#
# # respond to keys immediately (don't wait for enter)
# curses.cbreak()
#
# # map arrow keys to special values
# screen.keypad(True)
#
# try:
#     while True:
#         char = screen.getch()
#         if char == ord('q'):
#             break
#         elif char == curses.KEY_RIGHT:
#             # print doesn't work with curses, use addstr instead
#             screen.addstr(0, 0, 'right')
#         elif char == curses.KEY_LEFT:
#             screen.addstr(0, 0, 'left ')
#         elif char == curses.KEY_UP:
#             screen.addstr(0, 0, 'up   ')
#         elif char == curses.KEY_DOWN:
#             screen.addstr(0, 0, 'down ')
# finally:
#     # shut down cleanly
#     curses.nocbreak(); screen.keypad(0); curses.echo()
#     curses.endwin()
# import sys,tty,termios
#
# class _Getch:
#     def __call__(self):
#             fd = sys.stdin.fileno()
#             old_settings = termios.tcgetattr(fd)
#             try:
#                 tty.setraw(sys.stdin.fileno())
#                 ch = sys.stdin.read(1)
#             finally:
#                 termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
#             return ch
#
# def get():
#         inkey = _Getch()
#         print "{:02x}".format(13)
#         while(1):
#                 k=inkey()
#                 if k!='':break
#         if k=='\x1b[A':
#                 print "up"
#         elif k=='\x1b[B':
#                 print "down"
#         elif k=='\x1b[C':
#                 print "right"
#         elif k=='\x1b[D':
#                 print "left"
#         elif k=="\x1b^C":
#                 print "q"
#         else:
#                 print k
#                 # print "not an arrow key!"
#
# def main():
#         for i in range(0,20):
#                 get()
#
# if __name__=='__main__':
#         main()
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
    UP = "up" # 65
    DOWN = "down" # 66
    LEFT = "left" # 68
    RIGHT = "right" # 67
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

def main():
    while(True):
        print Keyboard.read()

if __name__=='__main__':
    main()
