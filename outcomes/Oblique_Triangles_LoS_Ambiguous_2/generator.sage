from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA ambiguous case: guaranteed two triangles
        A = random.randint(25, 40)  # acute angle
        
        # Generate realistic floats for sides (rounded to 1 decimal place)
        b = round(random.uniform(10.0, 14.0), 1)

        # Force ambiguous case: b*sin(A) < a < b
        lower = float(b * sin(A * pi / 180))
        a = round(random.uniform(lower + 0.5, b - 0.5), 1)

        # Law of Sines to find the first angle (B1)
        sinB = float(b * sin(A * pi / 180) / a)
        B1 = float(asin(sinB) * 180 / pi)
        
        # Calculate theoretical second angle and sum check
        B2 = 180.0 - B1
        sum_check = A + B2

        # Triangle 1 parameters
        C1 = 180.0 - A - B1
        c1 = float(a * sin(C1 * pi / 180) / sin(A * pi / 180))

        # Triangle 2 parameters
        C2 = 180.0 - A - B2
        c2 = float(a * sin(C2 * pi / 180) / sin(A * pi / 180))

        # Format solutions mathematically to adhere to the requested rounding rules
        B1_format = f"{B1:.1f}"
        B2_format = f"{B2:.1f}"
        sum_format = f"{sum_check:.1f}"
        C1_format = f"{C1:.1f}"
        c1_format = f"{c1:.2f}"
        C2_format = f"{C2:.1f}"
        c2_format = f"{c2:.2f}"

        # --- Build Step-by-Step Solution ---
        step1a = r"\text{Step 1: Dive in with the Law of Sines to find the first angle } B_1."
        step1b = r"\frac{\sin(B)}{b} = \frac{\sin(A)}{a}"
        step1c = rf"\sin(B) = \frac{{{b}\sin({A}^\circ)}}{{{a}}} \approx {sinB:.4f}"
        step1d = rf"B_1 = \sin^{{-1}}({sinB:.4f}) \approx {B1_format}^\circ"

        step2a = r"\text{Step 2: Check if a second triangle is possible.}"
        step2b = rf"\text{{The theoretical second angle is }} B_2 = 180^\circ - {B1_format}^\circ = {B2_format}^\circ."
        step2c = rf"\text{{Check if it fits with the given angle }} A: {A}^\circ + {B2_format}^\circ = {sum_format}^\circ."
        step2d = rf"\text{{Since }} {sum_format}^\circ < 180^\circ \text{{, there is room for a third angle! There are exactly TWO valid triangles.}}"

        step3a = r"\text{Step 3: Solve Triangle 1 (using } B_1 \text{).}"
        step3b = rf"\angle C_1 = 180^\circ - \angle A - B_1 \approx 180^\circ - {A}^\circ - {B1_format}^\circ = {C1_format}^\circ"
        step3c = r"c_1 = \frac{a\sin(C_1)}{\sin(A)}"
        step3d = rf"c_1 = \frac{{{a}\sin({C1_format}^\circ)}}{{\sin({A}^\circ)}} \approx {c1_format}"

        step4a = r"\text{Step 4: Solve Triangle 2 (using } B_2 \text{).}"
        step4b = rf"\angle C_2 = 180^\circ - \angle A - B_2 \approx 180^\circ - {A}^\circ - {B2_format}^\circ = {C2_format}^\circ"
        step4c = r"c_2 = \frac{a\sin(C_2)}{\sin(A)}"
        step4d = rf"c_2 = \frac{{{a}\sin({C2_format}^\circ)}}{{\sin({A}^\circ)}} \approx {c2_format}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step1d}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><strong><m>{step2d}</m></strong></p>",
            f"    <hr/>",
            f"    <p><m>{step3a}</m></p>",
            f"    <p><m>{step3b}</m></p>",
            f"    <p><m>{step3c}</m></p>",
            f"    <p><m>{step3d}</m></p>",
            f"    <hr/>",
            f"    <p><m>{step4a}</m></p>",
            f"    <p><m>{step4b}</m></p>",
            f"    <p><m>{step4c}</m></p>",
            f"    <p><m>{step4d}</m></p>"
        ]
        
        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "a": a,
            "b": b,
            "solution_steps": solution_steps
        }