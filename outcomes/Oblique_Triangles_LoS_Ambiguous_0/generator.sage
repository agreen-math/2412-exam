from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA case with no triangle possible:
        # a < b * sin(A)

        A = random.randint(25, 45)  # acute angle
        b = round(random.uniform(8.0, 14.0), 2)

        # Upper bound for no-triangle case
        upper = b * sin(A * pi / 180)

        # Ensure a is strictly less than b*sin(A)
        a = round(random.uniform(1.0, float(upper) - 0.5), 2)

        # Build the outtro to adhere to the Zero-Text Rule
        outtro = (
            f"<outtro>\n"
            f"    <p><em>No triangle is possible.</em></p>\n"
            f"</outtro>"
        )

        return {
            "A": A,
            "a": a,
            "b": b,
            "outtro": outtro
        }