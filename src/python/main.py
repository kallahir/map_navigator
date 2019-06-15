import os

from keyboard import Keyboard
from navigator import Navigator

def main():
    navigator = Navigator()

    while(True):
        os.system("clear")
        navigator.show_map()

        cmd = Keyboard.read()
        if cmd == Keyboard.CLOSE:
            # print "Do you want to save the map? Press 's' to save."
            # if Keyboard.read() == Keyboard.SAVE:
            #     print "Saving the map..."
            #     navigator.save_map()
            # else:
            #     print "Close without saving the map."
            exit(1)

        navigator.move(cmd)

if __name__ == "__main__":
    main()

