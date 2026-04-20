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
        # Side lengths with 3–6 significant digits
        a = sigfig(random.uniform(15.0, 95.0), random.randint(3, 6))
        b = sigfig(random.uniform(18.0, 98.0), random.randint(3, 6))

        # Avoid unit-circle angles
        forbidden = {30, 45, 60, 90, 120, 135, 150}

        while True:
            angle_candidate = sigfig(random.uniform(25.0, 155.0), random.randint(3, 6))
            if round(angle_candidate) not in forbidden:
                angle_deg = angle_candidate
                break

        angle_rad = angle_deg * pi / 180

        # Calculate exact and rounded area
        area_val = (1/2) * a * b * sin(angle_rad)
        area = round(float(area_val), 2)

        # Build the mathematical steps for the Zero-Text Rule
        step1 = r"\text{Area} = \frac{1}{2}ab\sin(C)"
        step2 = rf"= \frac{{1}}{{2}}({a})({b})\sin({angle_deg}^\circ)"
        final_ans = rf"\approx {area} \text{{ m}}^2"

        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{step2}</m></p>\n"
            f"    <p><m>{final_ans}</m></p>\n"
            f"</outtro>"
        )

        return {
            "a": a,
            "b": b,
            "angle_deg": angle_deg,
            "outtro": outtro
        }