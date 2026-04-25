from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate side lengths that always satisfy the triangle inequality
        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Ensure c < a + b
        c = round(random.uniform(abs(a - b) + 1.0, a + b - 1.0), 2)

        # Law of Cosines to find angle C
        cosC = (a**2 + b**2 - c**2) / (2 * a * b)
        C = arccos(cosC) * 180 / pi

        # Law of Cosines to find remaining angle A
        cosA = (b**2 + c**2 - a**2) / (2 * b * c)
        A = arccos(cosA) * 180 / pi

        B = 180 - A - C

        # Format solutions mathematically
        A_val = round(float(A), 1)
        B_val = round(float(B), 1)
        C_val = round(float(C), 1)

        # --- Step 1: Finding angle C ---
        step1a = r"\cos(C) = \frac{a^2 + b^2 - c^2}{2ab}"
        step1b = rf"C = \cos^{{-1}}\left(\frac{{{a}^2 + {b}^2 - {c}^2}}{{2({a})({b})}}\right)"
        step1c = rf"\angle C \approx {C_val}^\circ"

        # --- Step 2: Finding angle A ---
        step2a = r"\cos(A) = \frac{b^2 + c^2 - a^2}{2bc}"
        step2b = rf"A = \cos^{{-1}}\left(\frac{{{b}^2 + {c}^2 - {a}^2}}{{2({b})({c})}}\right)"
        step2c = rf"\angle A \approx {A_val}^\circ"

        # --- Step 3: Finding angle B ---
        step3a = r"\angle B = 180^\circ - \angle A - \angle C"
        step3b = rf"\angle B \approx 180^\circ - {A_val}^\circ - {C_val}^\circ \approx {B_val}^\circ"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><m>{step3a}</m></p>",
            f"    <p><m>{step3b}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "a": a,
            "b": b,
            "c": c,
            "solution_steps": solution_steps
        }