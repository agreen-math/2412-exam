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

        # --- Step 1: Finding angle C ---
        step1a = r"\angle C = 180^\circ - \angle A - \angle B"
        step1b = rf"\angle C = 180^\circ - {A}^\circ - {B}^\circ"
        step1c = rf"\angle C = {C_val}^\circ"

        # --- Step 2: Finding side a ---
        step2a = r"a = \frac{c\sin(A)}{\sin(C)}"
        step2b = rf"a = \frac{{{c}\sin({A}^\circ)}}{{\sin({C_val}^\circ)}}"
        step2c = rf"a \approx {a_val}"

        # --- Step 3: Finding side b ---
        step3a = r"b = \frac{c\sin(B)}{\sin(C)}"
        step3b = rf"b = \frac{{{c}\sin({B}^\circ)}}{{\sin({C_val}^\circ)}}"
        step3c = rf"b \approx {b_val}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><m>{step3a}</m></p>",
            f"    <p><m>{step3b}</m></p>",
            f"    <p><m>{step3c}</m></p>"
        ]
        
        # We now only return the inner HTML blocks, not the <outtro> tags themselves
        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "B": B,
            "c": c,
            "solution_steps": solution_steps
        }