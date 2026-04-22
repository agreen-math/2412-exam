from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA ambiguous case: guaranteed two triangles
        A = random.randint(25, 40)  # acute angle
        b = round(random.uniform(10.0, 14.0), 2)

        # Force ambiguous case: b*sin(A) < a < b
        lower = b * sin(A * pi / 180)
        a = round(random.uniform(float(lower) + 0.5, b - 0.5), 2)

        # Law of Sines
        sinB = b * sin(A * pi / 180) / a

        B1 = asin(sinB) * 180 / pi
        B2 = 180 - B1

        C1 = 180 - A - B1
        C2 = 180 - A - B2

        c1 = a * sin(C1 * pi / 180) / sin(A * pi / 180)
        c2 = a * sin(C2 * pi / 180) / sin(A * pi / 180)

        # Format variables cleanly
        B1_val = round(float(B1), 1)
        C1_val = round(float(C1), 1)
        c1_val = round(float(c1), 2)

        B2_val = round(float(B2), 1)
        C2_val = round(float(C2), 1)
        c2_val = round(float(c2), 2)

        # --- Triangle 1 Steps ---
        step1a = r"\text{Triangle 1:}"
        step1b = r"\sin(B_1) = \frac{b\sin(A)}{a}"
        step1c = rf"B_1 = \sin^{{-1}}\left(\frac{{{b}\sin({A}^\circ)}}{{{a}}}\right) \approx {B1_val}^\circ"
        step1d = rf"C_1 = 180^\circ - {A}^\circ - {B1_val}^\circ = {C1_val}^\circ"
        step1e = r"c_1 = \frac{a\sin(C_1)}{\sin(A)}"
        step1f = rf"c_1 = \frac{{{a}\sin({C1_val}^\circ)}}{{\sin({A}^\circ)}} \approx {c1_val}"

        # --- Triangle 2 Steps ---
        step2a = r"\text{Triangle 2:}"
        step2b = rf"B_2 = 180^\circ - B_1 \approx {B2_val}^\circ"
        step2c = rf"C_2 = 180^\circ - {A}^\circ - {B2_val}^\circ = {C2_val}^\circ"
        step2d = r"c_2 = \frac{a\sin(C_2)}{\sin(A)}"
        step2e = rf"c_2 = \frac{{{a}\sin({C2_val}^\circ)}}{{\sin({A}^\circ)}} \approx {c2_val}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step1c}</m></p>",
            f"    <p><m>{step1d}</m></p>",
            f"    <p><m>{step1e}</m></p>",
            f"    <p><m>{step1f}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><m>{step2d}</m></p>",
            f"    <p><m>{step2e}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "A": A,
            "a": a,
            "b": b,
            "solution_steps": solution_steps
        }