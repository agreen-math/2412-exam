from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # First leg parameters
        b1_deg = random.choice([28, 32, 35, 38])
        speed1 = random.choice([2.5, 3, 3.5])
        time1 = random.choice([1.5, 2, 2.5])

        # Second leg parameters (chosen to avoid right angles)
        b2_deg = random.choice([41, 47, 53, 59])
        speed2 = random.choice([2, 2.8, 3.2])
        time2 = random.choice([1.25, 1.75, 2.25])

        # Convert bearings to standard math angles (east = 0, CCW positive)
        theta1 = (90 - b1_deg) * pi / 180
        theta2 = (270 + b2_deg) * pi / 180

        # Distances traveled
        d1 = speed1 * time1
        d2 = speed2 * time2

        # Component displacements
        x = d1 * cos(theta1) + d2 * cos(theta2)
        y = d1 * sin(theta1) + d2 * sin(theta2)

        # Distance back to campsite
        dist_back = sqrt(x^2 + y^2)

        # Angle back to campsite (radians)
        angle_rad = atan2(-y, -x)

        # Convert to numeric degrees safely
        angle_deg = float(angle_rad * 180 / pi) % 360

        # Convert to acute-angle bearing form
        if angle_deg <= 90:
            bearing_cardinal = "N %0.1f^\\circ E" % angle_deg
        elif angle_deg <= 180:
            bearing_cardinal = "S %0.1f^\\circ E" % (180 - angle_deg)
        elif angle_deg <= 270:
            bearing_cardinal = "S %0.1f^\\circ W" % (angle_deg - 180)
        else:
            bearing_cardinal = "N %0.1f^\\circ W" % (360 - angle_deg)

        return {
            "b1_card": "N %d^\\circ E" % b1_deg,
            "b1_num": "%d^\\circ" % b1_deg,
            "speed1": speed1,
            "time1": time1,
            "b2_card": "S %d^\\circ E" % b2_deg,
            "b2_num": "%d^\\circ" % (180 + b2_deg),
            "speed2": speed2,
            "time2": time2,
            "dist_back": round(float(dist_back), 1),
            "bearing_cardinal": bearing_cardinal,
            "bearing_num": round(angle_deg, 1)
        }