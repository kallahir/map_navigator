class Point:
    BARRIER = -1
    CURRENT = 0
    CLEAR   = 1
    VISITED = 2
    UNKNOWN = 99

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def coordinates(self):
        return self.x, self.y

