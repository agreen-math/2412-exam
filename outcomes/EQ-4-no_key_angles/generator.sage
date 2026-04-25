from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        def get_ratio():
            # Standard Pythagorean triples to guarantee clean rational numbers (no roots)
            triples = [
                (3, 4, 5),
                (5, 12, 13)#,
#                (8, 15, 17),
#                (7, 24, 25)
            ]
            u, v, w = random.choice(triples)
            
            # Randomly pick one of the legs (u or v) for the numerator
            num = random.choice([u, v])
            
            # Randomly make it positive or negative
            sign = random.choice([1, -1])
            
            # The hypotenuse (w) is always the denominator for sin/cos
            return Integer(num * sign) / Integer(w)

        f2 = random.choice(["sin", "cos"])
        f3 = random.choice(["sin", "cos"])

        r2 = get_ratio()
        r3 = get_ratio()

        funcs = {
            "sin": arcsin,
            "cos": arccos
        }

        alpha = funcs[f2](r2)
        beta = funcs[f3](r3)

        # Evaluate the 4 components explicitly to show intermediate steps
        # Because we used triples, these will ALL be perfect fractions!
        sin_a = SR(sin(alpha)).simplify_full()
        cos_a = SR(cos(alpha)).simplify_full()
        sin_b = SR(sin(beta)).simplify_full()
        cos_b = SR(cos(beta)).simplify_full()

        # Final calculated value using angle addition formula
        x_val = SR(sin_a * cos_b + cos_a * sin_b).simplify_full()

        r2_tex = latex(r2)
        r3_tex = latex(r3)

        # --- Build the Step-by-Step Solution ---
        step1 = rf"x = \sin\left(\{f2}^{{-1}}\left({r2_tex}\right) + \{f3}^{{-1}}\left({r3_tex}\right)\right)"
        
        step2 = rf"\text{{Let }} \alpha = \{f2}^{{-1}}\left({r2_tex}\right) \text{{ and }} \beta = \{f3}^{{-1}}\left({r3_tex}\right)."
        
        step3 = r"x = \sin(\alpha + \beta) = \sin(\alpha)\cos(\beta) + \cos(\alpha)\sin(\beta)"
        
        step4 = r"\text{Evaluate the exact trigonometric values using reference triangles:}"
        step5 = rf"\sin(\alpha) = {latex(sin_a)}, \quad \cos(\alpha) = {latex(cos_a)}"
        step6 = rf"\sin(\beta) = {latex(sin_b)}, \quad \cos(\beta) = {latex(cos_b)}"
        
        step7 = rf"x = \left({latex(sin_a)}\right)\left({latex(cos_b)}\right) + \left({latex(cos_a)}\right)\left({latex(sin_b)}\right)"
        step8 = rf"x = {latex(x_val)}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p><m>{step4}</m></p>",
            f"    <p><m>{step5}</m></p>",
            f"    <p><m>{step6}</m></p>",
            f"    <p><m>{step7}</m></p>",
            f"    <p><m>{step8}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "f2": f2,
            "f3": f3,
            "r2_tex": r2_tex,
            "r3_tex": r3_tex,
            "solution_steps": solution_steps
        }