from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        A = random.randint(35, 65)
        B = random.randint(30, 55)

        if A + B >= 160:
            A = 45
            B = 50

        C = 180 - A - B

        c = round(random.uniform(6.0, 14.0), 2)

        a = c * sin(A * pi / 180) / sin(C * pi / 180)
        b = c * sin(B * pi / 180) / sin(C * pi / 180)

        return {
            "A": A,
            "B": B,
            
"C": round(C, 1),
            "a": round(float(a), 2),
            "b": round(float(b), 2),
            "c": c
        }

