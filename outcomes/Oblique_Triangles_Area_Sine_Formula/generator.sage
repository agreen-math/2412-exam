from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Two sides and the included angle

        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Included angle (avoid 0 and 180 degrees)
        C = random.randint(30, 150)

        # Area formula: (1/2)ab sin(C)
        area = 0.5 * a * b * sin(C * pi / 180)

        return {
            "a": a,
            "b": b,
            "C": C,
            "area": round(float(area), 2)
        }