from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate side lengths rounded to 1 decimal place to keep input clean
        a = round(random.uniform(15.0, 40.0), 1)
        b = round(random.uniform(15.0, 40.0), 1)
        
        # Ensure c produces a valid oblique triangle (a + b > c, etc.)
        c = round(random.uniform(abs(a - b) + 2.0, a + b - 2.0), 1)

        # Calculate semi-perimeter
        s = (a + b + c) / 2.0

        # Calculate area using Heron's formula
        area = sqrt(s * (s - a) * (s - b) * (s - c))

        # Format to strictly two decimal places to match the prompt's instructions
        s_format = f"{s:.2f}" 
        area_format = f"{area:.2f}"

        # --- Build Step-by-Step Solution ---
        step1a = r"\text{Step 1: Calculate the semi-perimeter } s."
        step1b = r"s = \frac{a + b + c}{2}"
        step1c = rf"s = \frac{{{a} + {b} + {c}}}{{2}} = {s_format}"
        
        step2a = r"\text{Step 2: Apply Heron's Formula.}"
        step2b = r"\text{Area} = \sqrt{s(s - a)(s - b)(s - c)}"
        step2c = rf"\text{{Area}} = \sqrt{{{s_format}({s_format} - {a})({s_format} - {b})({s_format} - {c})}}"
        
        # Show the intermediate product inside the square root to help students catch calculation errors
        inside_root = float(s * (s - a) * (s - b) * (s - c))
        step2d = rf"\text{{Area}} = \sqrt{{{inside_root:.4f}}} \approx {area_format}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><m>{step2d}</m></p>"
        ]
        
        solution_steps = "\n".join(outtro_lines)

        return {
            "a": a,
            "b": b,
            "c": c,
            "solution_steps": solution_steps
        }