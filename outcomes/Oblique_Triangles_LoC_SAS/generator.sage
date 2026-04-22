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

        # --- Step 1: Finding side c ---
        step1a = r"c^2 = a^2 + b^2 - 2ab\cos(C)"
        step1b = rf"c = \sqrt{{{a}^2 + {b}^2 - 2({a})({b})\cos({C}^\circ)}}"
        step1c = rf"c \approx {c_val}"

        # --- Step 2: Finding angle A ---
        step2a = r"\cos(A) = \frac{b^2 + c^2 - a^2}{2bc}"
        step2b = rf"A = \cos^{{-1}}\left(\frac{{{b}^2 + {c_val}^2 - {a}^2}}{{2({b})({c_val})}}\right)"
        step2c = rf"\angle A \approx {A_val}^\circ"

        # --- Step 3: Finding angle B ---
        step3a = rf"\angle B = 180^\circ - {A_val}^\circ - {C}^\circ"
        step3b = rf"\angle B \approx {B_val}^\circ"

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
        
        # Join all the lines together to inject between the physical <outtro> tags
        solution_steps = "\n".join(outtro_lines)

        return {
            "a": a,
            "b": b,
            "C": C,
            "solution_steps": solution_steps
        }