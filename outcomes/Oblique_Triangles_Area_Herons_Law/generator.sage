from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate side lengths that satisfy the triangle inequality
        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Ensure c produces a valid oblique triangle
        c = round(random.uniform(abs(a - b) + 1.0, a + b - 1.0), 2)

        # Semi-perimeter
        s = (a + b + c) / 2

        # Heron's formula
        area = sqrt(s * (s - a) * (s - b) * (s - c))

        return {
            "a": a,
            "b": b,
            "c": c,
            "area": round(float(area), 2)
        }