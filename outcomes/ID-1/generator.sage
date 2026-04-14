from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Select a variable to use for the problem
        v = random.choice(["x", r"\theta", "t"])

        # Define the problem configurations and their exact step-by-step solutions
        configs = [
            # Base Variation 1
            {
                "expr": rf"\cot {v} \cos {v} + \sin {v}",
                "steps": [
                    rf"\frac{{\cos {v}}}{{\sin {v}}} \cdot \cos {v} + \sin {v}",
                    rf"\frac{{\cos^2 {v}}}{{\sin {v}}} + \frac{{\sin^2 {v}}}{{\sin {v}}}",
                    rf"\frac{{1}}{{\sin {v}}}"
                ],
                "final": rf"\csc {v}"
            },
            # Base Variation 2
            {
                "expr": rf"\tan {v} \sin {v} + \cos {v}",
                "steps": [
                    rf"\frac{{\sin {v}}}{{\cos {v}}} \cdot \sin {v} + \cos {v}",
                    rf"\frac{{\sin^2 {v}}}{{\cos {v}}} + \frac{{\cos^2 {v}}}{{\cos {v}}}",
                    rf"\frac{{1}}{{\cos {v}}}"
                ],
                "final": rf"\sec {v}"
            },
            # Base Variation 3
            {
                "expr": rf"\csc {v} - \cot {v} \cos {v}",
                "steps": [
                    rf"\frac{{1}}{{\sin {v}}} - \frac{{\cos {v}}}{{\sin {v}}} \cdot \cos {v}",
                    rf"\frac{{1}}{{\sin {v}}} - \frac{{\cos^2 {v}}}{{\sin {v}}}",
                    rf"\frac{{\sin^2 {v}}}{{\sin {v}}}"
                ],
                "final": rf"\sin {v}"
            },
            # Base Variation 4
            {
                "expr": rf"\sec {v} - \tan {v} \sin {v}",
                "steps": [
                    rf"\frac{{1}}{{\cos {v}}} - \frac{{\sin {v}}}{{\cos {v}}} \cdot \sin {v}",
                    rf"\frac{{1}}{{\cos {v}}} - \frac{{\sin^2 {v}}}{{\cos {v}}}",
                    rf"\frac{{\cos^2 {v}}}{{\cos {v}}}"
                ],
                "final": rf"\cos {v}"
            }
        ]

        problem = random.choice(configs)

        # Assemble the outtro using the Zero-Text Rule
        outtro_lines = []
        for step in problem["steps"]:
            outtro_lines.append(f"    <p><m>{step}</m></p>")

        final_sol = rf"\boxed{{{problem['final']}}}"
        outtro_lines.append(f"    <p><m>{final_sol}</m></p>")

        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "expr": problem["expr"],
            "outtro": outtro
        }