from keyboard import Keyboard
from point import Point

class Navigator:
    def __init__(self):
        self.position = Point(0,0)
        self.map = [[Point.CURRENT]]
        self.x_offset = 0
        self.y_offset = 0

    def move(self, cmd):
        if cmd == Keyboard.UP:
            self.__execute_movement(cmd, x_modifier = -1)
        elif cmd == Keyboard.RIGHT:
            self.__execute_movement(cmd, y_modifier = 1)
        elif cmd == Keyboard.DOWN:
            self.__execute_movement(cmd, x_modifier = 1)
        elif cmd == Keyboard.LEFT:
            self.__execute_movement(cmd, y_modifier = -1)

    def show_map(self):
        print "Current Position => x: %d | y: %d" % (self.position.x, self.position.y)
        print "   x "
        print " y   ",
        for y in range(len(self.map[0])):
            print "%3d" % (y + self.y_offset),
        print

        x_count = 0
        for line in self.map:
            print  " %3d  " % (x_count + self.x_offset),
            y_count = 0
            for pos in line:
                if ((x_count + self.x_offset) == 0 and (y_count + self.y_offset) == 0) and pos != Point.CURRENT:
                    print " X ",
                elif pos == Point.UNKNOWN:
                    print " o ",
                elif pos == Point.VISITED:
                    print " o ",
                else:
                    print "<^>",
                y_count += 1
            print
            x_count += 1

    def __execute_movement(self, cmd, x_modifier = 0, y_modifier = 0):
        destination = Point(self.position.x + x_modifier, self.position.y + y_modifier)
        self.__expand_map(cmd, destination)

        self.map[self.position.x - self.x_offset][self.position.y - self.y_offset] = Point.VISITED
        self.map[destination.x - self.x_offset][destination.y - self.y_offset] = Point.CURRENT

        self.position = destination

    def __expand_map(self, cmd, destination):
        if cmd == Keyboard.UP:
            if destination.x > 0: return
            if destination.x >= self.x_offset: return

            self.map.insert(0, [Point.UNKNOWN] * len(self.map[0]))
            self.x_offset -= 1
        elif cmd == Keyboard.RIGHT:
            if destination.y < 0: return
            if destination.y < len(self.map[0]) + self.y_offset: return

            for line in self.map:
                line.append(Point.UNKNOWN)
        elif cmd == Keyboard.DOWN:
            if destination.x < 0: return
            if destination.x < len(self.map) + self.x_offset: return

            self.map.append([Point.UNKNOWN] * len(self.map[0]))
        elif cmd == Keyboard.LEFT:
            if destination.y > 0: return
            if destination.y >= self.y_offset: return

            for line in self.map:
                line.insert(0, Point.UNKNOWN)
            self.y_offset -= 1

