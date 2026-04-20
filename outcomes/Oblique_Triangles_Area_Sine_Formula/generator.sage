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
        area_val = round(float(area), 2)

        # Build the mathematical steps for the Zero-Text Rule
        step1 = r"\text{Area} = \frac{1}{2}ab\sin(C)"
        step2 = rf"\text{Area} = \frac{{1}}{{2}}({a})({b})\sin({C}^\circ)"
        step3 = rf"\text{Area} \approx {area_val} \text{{ square units}}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "a": a,
            "b": b,
            "C": C,
            "outtro": outtro
        }