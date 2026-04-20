from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SAS case: sides a, b and included angle C
        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Included angle (not right)
        C = random.randint(35, 120)

        # Law of Cosines to find side c
        c = sqrt(a**2 + b**2 - 2 * a * b * cos(C * pi / 180))

        # Law of Cosines to find angle A
        cosA = (b**2 + c**2 - a**2) / (2 * b * c)
        A = arccos(cosA) * 180 / pi

        # Remaining angle
        B = 180 - A - C

        # Format solutions mathematically to adhere to the Zero-Text Rule
        c_val = round(float(c), 2)
        A_val = round(float(A), 1)
        B_val = round(float(B), 1)

        step1 = rf"c \approx {c_val}"
        step2 = rf"\angle A \approx {A_val}^\circ"
        step3 = rf"\angle B \approx {B_val}^\circ"

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