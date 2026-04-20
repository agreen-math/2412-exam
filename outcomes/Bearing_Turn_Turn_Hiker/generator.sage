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

        # True bearing 1 (N b1_deg E)
        B1 = b1_deg
        theta1 = (90 - B1) * pi / 180
        
        # True bearing 2 (S b2_deg E)
        B2 = 180 - b2_deg
        theta2 = (90 - B2) * pi / 180

        # Distances traveled
        d1 = speed1 * time1
        d2 = speed2 * time2

        # Component displacements
        x = d1 * cos(theta1) + d2 * cos(theta2)
        y = d1 * sin(theta1) + d2 * sin(theta2)

        # Distance back to campsite (from terminal point to origin, vector is -x, -y)
        dist_back = sqrt((-x)**2 + (-y)**2)

        # Angle back to campsite (radians, standard math angle CCW from East)
        angle_rad = atan2(-y, -x)
        math_angle_deg = float(angle_rad * 180 / pi) % 360

        # Convert math angle accurately back to True Bearing
        true_bearing_back = (90 - math_angle_deg) % 360

        # Convert True Bearing to Cardinal Bearing safely
        if 0 <= true_bearing_back <= 90:
            bearing_cardinal = r"\text{N } %0.1f^\circ \text{ E}" % true_bearing_back
        elif 90 < true_bearing_back <= 180:
            bearing_cardinal = r"\text{S } %0.1f^\circ \text{ E}" % (180 - true_bearing_back)
        elif 180 < true_bearing_back <= 270:
            bearing_cardinal = r"\text{S } %0.1f^\circ \text{ W}" % (true_bearing_back - 180)
        else:
            bearing_cardinal = r"\text{N } %0.1f^\circ \text{ W}" % (360 - true_bearing_back)

        # Format variables cleanly
        dist_back_val = round(float(dist_back), 1)
        bearing_num_val = round(true_bearing_back, 1)

        # Assemble the outtro
        outtro = (
            f"<outtro>\n"
            f"    <p>The hiker must travel <m>{dist_back_val}</m> units to return to the campsite.</p>\n"
            f"    <p>The required bearing is <m>{bearing_cardinal}</m>, which may also be written as <m>{bearing_num_val}^\\circ</m>.</p>\n"
            f"</outtro>"
        )

        return {
            "b1_card": r"\text{N } %d^\circ \text{ E}" % b1_deg,
            "b1_num": f"{b1_deg}^\circ",
            "speed1": speed1,
            "time1": time1,
            "b2_card": r"\text{S } %d^\circ \text{ E}" % b2_deg,
            "b2_num": f"{180 - b2_deg}^\circ",
            "speed2": speed2,
            "time2": time2,
            "outtro": outtro
        }