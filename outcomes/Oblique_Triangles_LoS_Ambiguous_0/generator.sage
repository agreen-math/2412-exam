from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA case with exactly zero triangles guaranteed
        A = random.randint(25, 45)   # acute angle
        
        # Generate realistic float for side b
        b = round(random.uniform(8.0, 14.0), 1)

        # Force zero-triangle case: a < b * sin(A)
        # Calculate the physical height (h) to ensure side 'a' is strictly smaller
        h = float(b * sin(A * pi / 180))
        a = round(random.uniform(h * 0.4, h * 0.8), 1)

        # Law of Sines to find Angle B (This will safely calculate a ratio > 1)
        sinB = float(b * sin(A * pi / 180) / a)

        # --- Build Step-by-Step Solution ---
        step1a = r"\text{Step 1: Dive in with the Law of Sines to find angle } B."
        step1b = r"\frac{\sin(B)}{b} = \frac{\sin(A)}{a}"
        step1c = rf"\sin(B) = \frac{{{b}\sin({A}^\circ)}}{{{a}}} \approx {sinB:.4f}"
        
        step2a = r"\text{Step 2: Attempt to find the angle using inverse sine.}"
        step2b = rf"B = \sin^{{-1}}({sinB:.4f})"
        step2c = rf"\text{{Wait! The domain of the inverse sine function is }} [-1, 1]\text{{, but }} {sinB:.4f} > 1."
        step2d = r"\text{If you type this into a calculator, you will get a domain error. Geometrically, this tells us the swinging side } a \text{ is too short to reach the base.}"
        step2e = r"\text{Therefore, there are exactly ZERO valid triangles.}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><strong><m>{step2c}</m></strong></p>",
            f"    <p><m>{step2d}</m></p>",
            f"    <p><strong><m>{step2e}</m></strong></p>"
        ]
        
        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "a": a,
            "b": b,
            "solution_steps": solution_steps
        }