import random
from point import Point

class Sensor:
    ROBOT_SIZE = 15.5 # Diameter in cm
    MAX_RANGE = 340.0 # Real MAX range is 400cm | 15% of safe distance

    def read(self):
        distance_to_obstacle = self.__read_sensor_data()

        if distance_to_obstacle > self.MAX_RANGE:
            positions_clear = int(self.MAX_RANGE/self.ROBOT_SIZE)

            position = [Point.CLEAR] * positions_clear
            position.append(Point.UNKNOWN)

            return position

        positions_clear = int(distance_to_obstacle/self.ROBOT_SIZE)

        if positions_clear == 0:
            return [Point.BARRIER]

        positions = [Point.CLEAR] * positions_clear
        positions.append(Point.BARRIER)

        return positions

    def __read_sensor_data(self):
        return random.uniform(10.0,400.0)
