from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # ----------------------------
        # Random choices
        # ----------------------------
        
        outer = random.choice(["sin", "cos"])
        inv1 = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])
        inv2 = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])
        op = random.choice(["+", "-"])

        # Completely random integer pools to force irrational hypotenuses
        # Kept under 10 so the final multiplied radical denominators don't exceed ~200
        pos_pool = list(range(2, 10))
        all_pool = list(range(-9, -1)) + list(range(2, 10))

        # ----------------------------
        # CRITICAL DOMAIN ENFORCEMENT
        # ----------------------------
        
        # Alpha (Angle 1)
        if inv1 in ["sin", "tan", "csc"]:
            x1 = random.choice(pos_pool)
            y1 = random.choice(all_pool)
        else: # cos, sec, cot
            y1 = random.choice(pos_pool)
            x1 = random.choice(all_pool)

        # Beta (Angle 2)
        if inv2 in ["sin", "tan", "csc"]:
            x2 = random.choice(pos_pool)
            y2 = random.choice(all_pool)
        else: # cos, sec, cot
            y2 = random.choice(pos_pool)
            x2 = random.choice(all_pool)

        # Calculate symbolic radii (these will frequently be irrational!)
        r1 = SR(sqrt(x1**2 + y1**2)).simplify_full()
        r2 = SR(sqrt(x2**2 + y2**2)).simplify_full()

        # ----------------------------
        # Mathematical Ratios
        # ----------------------------
        
        sin_a = SR(y1) / r1
        cos_a = SR(x1) / r1
        sin_b = SR(y2) / r2
        cos_b = SR(x2) / r2

        # Build inverse-trig arguments securely
        def get_arg(inv, sin_val, cos_val, x_val, y_val, r_val):
            if inv == "sin": return sin_val
            elif inv == "cos": return cos_val
            elif inv == "tan": return SR(y_val) / SR(x_val)
            elif inv == "csc": return r_val / SR(y_val)
            elif inv == "sec": return r_val / SR(x_val)
            else: return SR(x_val) / SR(y_val) # cot

        arg1 = get_arg(inv1, sin_a, cos_a, x1, y1, r1)
        arg2 = get_arg(inv2, sin_b, cos_b, x2, y2, r2)

        # Natively format the arguments
        arg1_tex = latex(arg1.simplify_full())
        arg2_tex = latex(arg2.simplify_full())
        
        expression = rf"\{outer}\left( \{inv1}^{{-1}}\left({arg1_tex}\right) {op} \{inv2}^{{-1}}\left({arg2_tex}\right) \right)"

        # ----------------------------
        # Apply Sum/Difference Identities
        # ----------------------------
        
        if outer == "sin":
            if op == "+":
                ans = sin_a * cos_b + cos_a * sin_b
                identity = r"\sin(\alpha + \beta) = \sin(\alpha)\cos(\beta) + \cos(\alpha)\sin(\beta)"
                plug_tex = rf"\left({latex(sin_a)}\right)\left({latex(cos_b)}\right) + \left({latex(cos_a)}\right)\left({latex(sin_b)}\right)"
            else:
                ans = sin_a * cos_b - cos_a * sin_b
                identity = r"\sin(\alpha - \beta) = \sin(\alpha)\cos(\beta) - \cos(\alpha)\sin(\beta)"
                plug_tex = rf"\left({latex(sin_a)}\right)\left({latex(cos_b)}\right) - \left({latex(cos_a)}\right)\left({latex(sin_b)}\right)"
        else: # cos
            if op == "+":
                ans = cos_a * cos_b - sin_a * sin_b
                identity = r"\cos(\alpha + \beta) = \cos(\alpha)\cos(\beta) - \sin(\alpha)\sin(\beta)"
                plug_tex = rf"\left({latex(cos_a)}\right)\left({latex(cos_b)}\right) - \left({latex(sin_a)}\right)\left({latex(sin_b)}\right)"
            else:
                ans = cos_a * cos_b + sin_a * sin_b
                identity = r"\cos(\alpha - \beta) = \cos(\alpha)\cos(\beta) + \sin(\alpha)\sin(\beta)"
                plug_tex = rf"\left({latex(cos_a)}\right)\left({latex(cos_b)}\right) + \left({latex(sin_a)}\right)\left({latex(sin_b)}\right)"

        # Let SageMath natively format the final simplified answer
        ans_tex = latex(ans.simplify_full())

        # Determine quadrants for pedagogical readout
        quad_a = "I" if (x1 > 0 and y1 > 0) else "II" if (x1 < 0) else "IV"
        quad_b = "I" if (x2 > 0 and y2 > 0) else "II" if (x2 < 0) else "IV"

        # ----------------------------
        # Build the Step-by-Step Solution
        # ----------------------------
        
        step1 = rf"\text{{Let }} \alpha = \{inv1}^{{-1}}\left({arg1_tex}\right) \text{{ and }} \beta = \{inv2}^{{-1}}\left({arg2_tex}\right)."
        step2 = rf"\text{{Based on principal domains, }} \alpha \text{{ is in Quadrant }} {quad_a} \text{{ and }} \beta \text{{ is in Quadrant }} {quad_b}."
        
        step3 = r"\text{Using the reference triangles, we identify the sides:}"
        step4 = rf"\text{{For }} \alpha: x = {x1}, \quad y = {y1}, \quad r = {latex(r1)}"
        step5 = rf"\text{{For }} \beta: x = {x2}, \quad y = {y2}, \quad r = {latex(r2)}"
        
        step6 = r"\text{Evaluate the fundamental trigonometric ratios:}"
        step7 = rf"\sin(\alpha) = {latex(sin_a)}, \quad \cos(\alpha) = {latex(cos_a)}"
        step8 = rf"\sin(\beta) = {latex(sin_b)}, \quad \cos(\beta) = {latex(cos_b)}"
        
        step9 = r"\text{Apply the sum/difference identity:}"
        step10 = identity
        step11 = rf"\{outer}(\alpha {op} \beta) = {plug_tex}"
        step12 = rf"\{outer}(\alpha {op} \beta) = {ans_tex}"

        outtro_lines = [
            f"    <p><em>Solution:</em></p>",
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p><m>{step4}</m></p>",
            f"    <p><m>{step5}</m></p>",
            f"    <p><m>{step6}</m></p>",
            f"    <p><m>{step7}</m></p>",
            f"    <p><m>{step8}</m></p>",
            f"    <p><m>{step9}</m></p>",
            f"    <p><m>{step10}</m></p>",
            f"    <p><m>{step11}</m></p>",
            f"    <p><m>{step12}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "expression": expression,
            "solution_steps": solution_steps
        }