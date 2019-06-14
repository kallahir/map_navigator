from keyboard import Keyboard
from point import Point

class Navigator:
    def __init__(self):
        self.position = Point(0,0)
        self.map = [[Point.CURRENT]]
        self.x_offset = 0
        self.y_offset = 0

    def move(self, cmd):
        print cmd

    def show_map(self):
        print self.map

