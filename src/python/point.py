class Point:
    UNKNOWN = 99
    CURRENT = 0
    VISITED = 1
    BARRIER = -1

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def coordinates(self):
        return self.x, self.y

