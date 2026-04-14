from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        r = round(random.uniform(5.0, 15.0), 2)
        theta = random.randint(20, 340)

        x = r * cos(theta * pi / 180)
        y = r * sin(theta * pi / 180)

        return {
            "r": r,
            "theta": theta,
            "x": round(float(x), 2),
            "y": round(float(y), 2)
        }