from keyboard import Keyboard
from point import Point
from colorama import Back, Fore, Style
import os

class Navigator:
    MAP_FILE = './data/map'

    def __init__(self):
        self.map, self.position, self.x_offset, self.y_offset = self.__load_map()

    def move(self, cmd):
        if cmd == Keyboard.UP:
            self.__execute_movement(cmd, x_modifier = -1)
        elif cmd == Keyboard.RIGHT:
            self.__execute_movement(cmd, y_modifier = 1)
        elif cmd == Keyboard.DOWN:
            self.__execute_movement(cmd, x_modifier = 1)
        elif cmd == Keyboard.LEFT:
            self.__execute_movement(cmd, y_modifier = -1)

    def save_map(self):
        with open(self.MAP_FILE, "w") as map_file:
            separator = ","
            new_line = "\n"
            map_file.write(str(self.position.x) + separator + str(self.position.y) + new_line)
            map_file.write(str(self.x_offset) + separator + str(self.y_offset) + new_line)
            for line in self.map:
                map_file.write(separator.join(str(i) for i in line))
                map_file.write(new_line)
            map_file.close()

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
                    print (Fore.BLACK + Back.YELLOW + " X "),
                elif pos == Point.UNKNOWN:
                    print (Fore.WHITE + Back.BLUE + " o "),
                elif pos == Point.VISITED:
                    print (Fore.WHITE + Back.GREEN + " o "),
                else:
                    print (Fore.WHITE + Back.RED + "<^>"),
                y_count += 1
            print Style.RESET_ALL
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

    def __load_map(self):
        if os.path.isfile(self.MAP_FILE):
            map_loaded = []
            map_file = open(self.MAP_FILE, "r")

            x, y = map_file.readline().split(",")
            x_off, y_off = map_file.readline().split(",")

            for line in map_file.readlines():
                map_loaded.append([int(i) for i in line.split(",")])

            return map_loaded, Point(int(x),int(y)), int(x_off), int(y_off)

        return [[Point.CURRENT]], Point(0,0), 0, 0

