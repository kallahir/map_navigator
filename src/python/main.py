import os

from keyboard import Keyboard
from navigator import Navigator

def main():
    navigator = Navigator()

    while(True):
        os.system("clear")
        navigator.show_map()
        navigator.move(Keyboard.read())

if __name__ == "__main__":
    main()

