from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA ambiguous case: guaranteed two triangles

        A = random.randint(25, 40)  # acute angle
        b = round(random.uniform(10.0, 14.0), 2)

        # Force ambiguous case: b*sin(A) < a < b
        lower = b * sin(A * pi / 180)
        a = round(random.uniform(float(lower) + 0.5, b - 0.5), 2)

        # Law of Sines
        sinB = b * sin(A * pi / 180) / a

        B1 = asin(sinB) * 180 / pi
        B2 = 180 - B1

        C1 = 180 - A - B1
        C2 = 180 - A - B2

        c1 = a * sin(C1 * pi / 180) / sin(A * pi / 180)
        c2 = a * sin(C2 * pi / 180) / sin(A * pi / 180)

        return {
            "A": A,
            "a": a,
            "b": b,

            "B1": round(float(B1), 1),
            "C1": round(float(C1), 1),
            "c1": round(float(c1), 2),

            "B2": round(float(B2), 1),
            "C2": round(float(C2), 1),
            "c2": round(float(c2), 2)
        }