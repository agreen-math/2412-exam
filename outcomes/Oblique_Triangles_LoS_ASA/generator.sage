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

        # Format solutions mathematically to adhere to the Zero-Text Rule
        C_val = round(float(C), 1)
        a_val = round(float(a), 2)
        b_val = round(float(b), 2)

        step1 = rf"\angle C \approx {C_val}^\circ"
        step2 = rf"a \approx {a_val}"
        step3 = rf"b \approx {b_val}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "A": A,
            "B": B,
            "c": c,
            "outtro": outtro
        }