from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA case with exactly one triangle guaranteed

        A = random.randint(25, 45)   # acute angle
        b = round(random.uniform(6.0, 10.0), 2)

        # Force one-triangle case: a >= b
        a = round(random.uniform(b + 0.5, b + 6.0), 2)

        # Law of Sines
        sinB = b * sin(A * pi / 180) / a
        B = arcsin(sinB) * 180 / pi
        C = 180 - A - B

        c = a * sin(C * pi / 180) / sin(A * pi / 180)

        # Format solutions mathematically to adhere to the Zero-Text Rule
        B_val = round(float(B), 1)
        C_val = round(float(C), 1)
        c_val = round(float(c), 2)

        step1 = rf"\angle B \approx {B_val}^\circ"
        step2 = rf"\angle C \approx {C_val}^\circ"
        step3 = rf"c \approx {c_val}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "A": A,
            "a": a,
            "b": b,
            "outtro": outtro
        }