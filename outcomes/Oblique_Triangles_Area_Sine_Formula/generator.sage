from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate clean integer side lengths and angle
        a = random.randint(5, 25)
        b = random.randint(5, 25)
        C = random.randint(30, 150)

        # Calculate area using SageMath's exact pi and evaluate to float
        area_val = 0.5 * a * b * float(sin(C * pi / 180))
        
        # Format strictly to the nearest hundredth as requested by the prompt
        formatted_area = f"{area_val:.2f}"

        # --- Build Step-by-Step Solution ---
        step1 = r"\text{Area} = \frac{1}{2}ab\sin(C)"
        step2 = rf"\text{{Area}} = \frac{{1}}{{2}}({a})({b})\sin({C}^\circ)"
        
        # Show the intermediate product of 1/2 * a * b
        coeff = 0.5 * a * b
        step3 = rf"\text{{Area}} = {coeff:g}\sin({C}^\circ)"
        step4 = rf"\text{{Area}} \approx {formatted_area}"

        outtro_lines = [
            f"    <p>We are given two sides and the included angle (SAS). We use the trigonometric area formula:</p>",
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p><m>{step4}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "a": a,
            "b": b,
            "C": C,
            "solution_steps": solution_steps
        }