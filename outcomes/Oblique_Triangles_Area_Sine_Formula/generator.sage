from sage.all import *
import random
import math


def sigfig(x, n):
    """
    Round x to n significant figures.
    x must be nonzero.
    """
    if x == 0:
        return 0
    return round(x, n - int(math.floor(math.log10(abs(x)))) - 1)


class Generator(BaseGenerator):
    def data(self):
        # Side lengths
        a = sigfig(random.uniform(5, 20), 3)
        b = sigfig(random.uniform(6, 25), 3)

        # Included angle (degrees)
        C = sigfig(random.uniform(30, 150), 3)
        C_rad = math.radians(C)

        # Area using sine formula
        Area = 0.5 * a * b * math.sin(C_rad)
        Area = sigfig(Area, 3)

        return {
            "a": a,
            "b": b,
            "C": C,
            "Area": Area
        }