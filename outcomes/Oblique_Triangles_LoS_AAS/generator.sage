from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate clean integer angles
        A = random.randint(30, 55)
        C = random.randint(35, 70)

        # Fallback to ensure valid triangle
        if A + C >= 160:
            A = 40
            C = 55

        # Calculate missing angle B
        B = 180 - A - C

        # Generate a realistic float for side a (rounded to 1 decimal place for clean input)
        a = round(random.uniform(6.0, 14.0), 1)

        # Calculate missing sides using Law of Sines
        # a / sin(A) = b / sin(B) = c / sin(C)
        b_val = float(a * sin(B * pi / 180) / sin(A * pi / 180))
        c_val = float(a * sin(C * pi / 180) / sin(A * pi / 180))

        # Format solutions mathematically to adhere to the requested rounding rules
        # Sides to nearest hundredth, angles to nearest tenth
        B_format = f"{float(B):.1f}"
        b_format = f"{b_val:.2f}"
        c_format = f"{c_val:.2f}"

        # --- Build Step-by-Step Solution ---
        step1a = r"\text{Step 1: Find the missing angle } B."
        step1b = rf"\angle B = 180^\circ - \angle A - \angle C"
        step1c = rf"\angle B = 180^\circ - {A}^\circ - {C}^\circ = {B_format}^\circ"

        step2a = r"\text{Step 2: Use the Law of Sines to find side } b."
        step2b = r"\frac{b}{\sin(B)} = \frac{a}{\sin(A)}"
        step2c = rf"b = \frac{{{a}\sin({B}^\circ)}}{{\sin({A}^\circ)}} \approx {b_format}"

        step3a = r"\text{Step 3: Use the Law of Sines to find side } c."
        step3b = r"\frac{c}{\sin(C)} = \frac{a}{\sin(A)}"
        step3c = rf"c = \frac{{{a}\sin({C}^\circ)}}{{\sin({A}^\circ)}} \approx {c_format}"

        outtro_lines = [
            f"    <p>We are given two angles and a non-included side (AAS). This defines a single, unique triangle.</p>",
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
        
        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "C": C,
            "a": a,
            "solution_steps": solution_steps
        }