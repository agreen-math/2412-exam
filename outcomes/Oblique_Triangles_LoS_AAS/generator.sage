from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        A = random.randint(30, 55)
        C = random.randint(35, 70)

        if A + C >= 160:
            A = 40
            C = 55

        B = 180 - A - C

        a = round(random.uniform(6.0, 14.0), 2)

        b = a * sin(B * pi / 180) / sin(A * pi / 180)
        c = a * sin(C * pi / 180) / sin(A * pi / 180)

        return {
            "A": A,
            "B": round(B, 1),
            "C": C,
            "a": a,
            "b": round(float(b), 2),
            "c": round(float(c), 2)
        }

