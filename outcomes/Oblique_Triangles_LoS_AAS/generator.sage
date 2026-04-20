from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        A = random.randint(30, 55)
        C = random.randint(35, 70)

        # Fallback to ensure valid triangle
        if A + C >= 160:
            A = 40
            C = 55

        B = 180 - A - C

        a = round(random.uniform(6.0, 14.0), 2)

        # Law of Sines
        b = a * sin(B * pi / 180) / sin(A * pi / 180)
        c = a * sin(C * pi / 180) / sin(A * pi / 180)

        # Format solutions mathematically to adhere to the Zero-Text Rule
        B_val = round(float(B), 1)
        b_val = round(float(b), 2)
        c_val = round(float(c), 2)

        step1 = rf"\angle B \approx {B_val}^\circ"
        step2 = rf"b \approx {b_val}"
        step3 = rf"c \approx {c_val}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "A": A,
            "C": C,
            "a": a,
            "outtro": outtro
        }