from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA case with exactly one triangle guaranteed

        A = random.randint(25, 45)   # acute angle
        # Generate realistic floats for sides (rounded to 1 decimal place for clean input)
        b = round(random.uniform(6.0, 10.0), 1)

        # Force one-triangle case: a >= b
        a = round(random.uniform(b + 0.5, b + 6.0), 1)

        # Law of Sines to find Angle B (B1)
        sinB = float(b * sin(A * pi / 180) / a)
        B1 = float(arcsin(sinB) * 180 / pi)
        
        # Calculate theoretical second angle and sum check
        B2 = 180.0 - B1
        sum_check = A + B2
        
        # Triangle Angle Sum to find Angle C
        C = 180.0 - A - B1

        # Law of Sines to find side c
        c = float(a * sin(C * pi / 180) / sin(A * pi / 180))

        # Format solutions mathematically to adhere to the requested rounding rules
        B1_format = f"{B1:.1f}"
        B2_format = f"{B2:.1f}"
        sum_format = f"{sum_check:.1f}"
        C_format = f"{C:.1f}"
        c_format = f"{c:.2f}"

        # --- Build Step-by-Step Solution ---
        step1a = r"\text{Step 1: Dive in with the Law of Sines to find the first angle } B_1."
        step1b = r"\frac{\sin(B)}{b} = \frac{\sin(A)}{a}"
        step1c = rf"\sin(B) = \frac{{{b}\sin({A}^\circ)}}{{{a}}} \approx {sinB:.4f}"
        step1d = rf"B_1 = \sin^{-1}({sinB:.4f}) \approx {B1_format}^\circ"

        step2a = r"\text{Step 2: Check if a second triangle is possible.}"
        step2b = rf"\text{{The theoretical second angle is }} B_2 = 180^\circ - {B1_format}^\circ = {B2_format}^\circ."
        step2c = rf"\text{{Check if it fits with the given angle }} A: {A}^\circ + {B2_format}^\circ = {sum_format}^\circ."
        step2d = rf"\text{{Since }} {sum_format}^\circ \ge 180^\circ \text{{, the triangle overflows! There is exactly ONE valid triangle.}}"

        step3a = r"\text{Step 3: Find the missing angle } C."
        step3b = rf"\angle C = 180^\circ - \angle A - B_1"
        step3c = rf"\angle C \approx 180^\circ - {A}^\circ - {B1_format}^\circ = {C_format}^\circ"

        step4a = r"\text{Step 4: Use the Law of Sines to find side } c."
        step4b = r"\frac{c}{\sin(C)} = \frac{a}{\sin(A)}"
        step4c = rf"c = \frac{{{a}\sin({C_format}^\circ)}}{{\sin({A}^\circ)}} \approx {c_format}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step1d}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><strong><m>{step2d}</m></strong></p>",
            f"    <p><m>{step3a}</m></p>",
            f"    <p><m>{step3b}</m></p>",
            f"    <p><m>{step3c}</m></p>",
            f"    <p><m>{step4a}</m></p>",
            f"    <p><m>{step4b}</m></p>",
            f"    <p><m>{step4c}</m></p>"
        ]
        
        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "a": a,
            "b": b,
            "solution_steps": solution_steps
        }