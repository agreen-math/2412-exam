from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA case with exactly one triangle guaranteed

        A = random.randint(25, 45)   # acute angle
        b = round(random.uniform(6.0, 10.0), 2)

        # Force one-triangle case: a >= b
        a = round(random.uniform(b + 0.5, b + 6.0), 2)

        # Law of Sines
        sinB = b * sin(A * pi / 180) / a
        B = asin(sinB) * 180 / pi
        C = 180 - A - B

        c = a * sin(C * pi / 180) / sin(A * pi / 180)

        return {
            "A": A,
            "a": a,
            "b": b,
            "B": round(float(B), 1),
            "C": round(float(C), 1),
            "c": round(float(c), 2)
        }