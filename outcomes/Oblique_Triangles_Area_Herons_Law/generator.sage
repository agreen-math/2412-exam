from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate side lengths that satisfy the triangle inequality
        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Ensure c produces a valid oblique triangle
        c = round(random.uniform(abs(a - b) + 1.0, a + b - 1.0), 2)

        # Semi-perimeter
        s = (a + b + c) / 2

        # Heron's formula
        area = sqrt(s * (s - a) * (s - b) * (s - c))

        # Format variables for clean display
        s_val = round(float(s), 2)
        area_val = round(float(area), 2)

        # Build the mathematical steps for the Zero-Text Rule
        step1 = rf"s = \frac{{{a} + {b} + {c}}}{{2}} = {s_val}"
        step2 = rf"\text{{Area}} = \sqrt{{{s_val}({s_val} - {a})({s_val} - {b})({s_val} - {c})}}"
        step3 = rf"\text{{Area}} \approx {area_val}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "a": a,
            "b": b,
            "c": c,
            "outtro": outtro
        }