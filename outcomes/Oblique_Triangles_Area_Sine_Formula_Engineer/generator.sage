from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate realistic floats rounded to 1 decimal place for the engineering context
        a = round(random.uniform(15.0, 95.0), 1)
        b = round(random.uniform(18.0, 98.0), 1)

        # Generate a non-unit-circle angle rounded to 1 decimal place
        forbidden = {30, 45, 60, 90, 120, 135, 150}
        while True:
            angle_deg = round(random.uniform(25.0, 155.0), 1)
            if round(angle_deg) not in forbidden:
                break

        # Calculate area using SageMath's exact pi, evaluate to float
        area_val = 0.5 * a * b * float(sin(angle_deg * pi / 180))

        # Format strictly to the nearest hundredth to match the prompt's instructions
        formatted_area = f"{area_val:.2f}"

        # --- Build Step-by-Step Solution ---
        step1 = r"\text{Area} = \frac{1}{2}ab\sin(C)"
        step2 = rf"\text{{Area}} = \frac{{1}}{{2}}({a})({b})\sin({angle_deg}^\circ)"

        # Show the intermediate product of 1/2 * a * b
        coeff = 0.5 * a * b
        step3 = rf"\text{{Area}} = {coeff:g}\sin({angle_deg}^\circ)"
        step4 = rf"\text{{Area}} \approx {formatted_area} \text{{ m}}^2"

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
            "angle_deg": angle_deg,
            "solution_steps": solution_steps
        }