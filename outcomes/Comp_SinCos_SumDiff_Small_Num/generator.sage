from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Helper to cleanly format radicals and fractions
        def format_math(expr):
            expr = SR(expr).simplify_full()
            if expr in QQ:
                return latex(expr)
            
            num = expr.numerator()
            den = expr.denominator()
            
            if den == 1:
                return latex(num)
                
            # Safely handle negatives to put the minus sign outside the fraction
            if bool(expr < 0):
                return rf"-\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"
            else:
                return rf"\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"

        # ----------------------------
        # Random choices
        # ----------------------------
        
        outer = random.choice(["sin", "cos"])
        inv1 = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])
        inv2 = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])
        op = random.choice(["+", "-"])

        # Use Pythagorean Triples for clean fraction arithmetic
        triples = [
            (3, 4, 5), (4, 3, 5),
            (5, 12, 13), (12, 5, 13),
            (8, 15, 17), (15, 8, 17),
            (7, 24, 25), (24, 7, 25)
        ]
        
        base_x1, base_y1, r1 = random.choice(triples)
        base_x2, base_y2, r2 = random.choice(triples)

        # ----------------------------
        # CRITICAL DOMAIN ENFORCEMENT
        # ----------------------------
        
        # Alpha (Angle 1)
        if inv1 in ["sin", "tan", "csc"]:
            x1 = base_x1
            y1 = base_y1 * random.choice([1, -1])
        else: # cos, sec, cot
            y1 = base_y1
            x1 = base_x1 * random.choice([1, -1])

        # Beta (Angle 2)
        if inv2 in ["sin", "tan", "csc"]:
            x2 = base_x2
            y2 = base_y2 * random.choice([1, -1])
        else: # cos, sec, cot
            y2 = base_y2
            x2 = base_x2 * random.choice([1, -1])

        # ----------------------------
        # Mathematical Ratios
        # ----------------------------
        
        sin_a = SR(y1) / SR(r1)
        cos_a = SR(x1) / SR(r1)
        sin_b = SR(y2) / SR(r2)
        cos_b = SR(x2) / SR(r2)

        # Build inverse-trig arguments securely
        def get_arg(inv, sin_val, cos_val, x_val, y_val, r_val):
            if inv == "sin": return sin_val
            elif inv == "cos": return cos_val
            elif inv == "tan": return SR(y_val) / SR(x_val)
            elif inv == "csc": return SR(r_val) / SR(y_val)
            elif inv == "sec": return SR(r_val) / SR(x_val)
            else: return SR(x_val) / SR(y_val) # cot

        arg1 = get_arg(inv1, sin_a, cos_a, x1, y1, r1)
        arg2 = get_arg(inv2, sin_b, cos_b, x2, y2, r2)

        arg1_tex = format_math(arg1)
        arg2_tex = format_math(arg2)
        
        expression = rf"\{outer}\left( \{inv1}^{{-1}}\left({arg1_tex}\right) {op} \{inv2}^{{-1}}\left({arg2_tex}\right) \right)"

        # ----------------------------
        # Apply Sum/Difference Identities
        # ----------------------------
        
        if outer == "sin":
            if op == "+":
                ans = sin_a * cos_b + cos_a * sin_b
                identity = r"\sin(\alpha + \beta) = \sin(\alpha)\cos(\beta) + \cos(\alpha)\sin(\beta)"
                plug_tex = rf"\left({format_math(sin_a)}\right)\left({format_math(cos_b)}\right) + \left({format_math(cos_a)}\right)\left({format_math(sin_b)}\right)"
            else:
                ans = sin_a * cos_b - cos_a * sin_b
                identity = r"\sin(\alpha - \beta) = \sin(\alpha)\cos(\beta) - \cos(\alpha)\sin(\beta)"
                plug_tex = rf"\left({format_math(sin_a)}\right)\left({format_math(cos_b)}\right) - \left({format_math(cos_a)}\right)\left({format_math(sin_b)}\right)"
        else: # cos
            if op == "+":
                ans = cos_a * cos_b - sin_a * sin_b
                identity = r"\cos(\alpha + \beta) = \cos(\alpha)\cos(\beta) - \sin(\alpha)\sin(\beta)"
                plug_tex = rf"\left({format_math(cos_a)}\right)\left({format_math(cos_b)}\right) - \left({format_math(sin_a)}\right)\left({format_math(sin_b)}\right)"
            else:
                ans = cos_a * cos_b + sin_a * sin_b
                identity = r"\cos(\alpha - \beta) = \cos(\alpha)\cos(\beta) + \sin(\alpha)\sin(\beta)"
                plug_tex = rf"\left({format_math(cos_a)}\right)\left({format_math(cos_b)}\right) + \left({format_math(sin_a)}\right)\left({format_math(sin_b)}\right)"

        ans_tex = format_math(ans.simplify_full())

        # Determine quadrants for pedagogical readout
        quad_a = "I" if (x1 > 0 and y1 > 0) else "II" if (x1 < 0) else "IV"
        quad_b = "I" if (x2 > 0 and y2 > 0) else "II" if (x2 < 0) else "IV"

        # ----------------------------
        # Build the Step-by-Step Solution
        # ----------------------------
        
        step1 = rf"\text{{Let }} \alpha = \{inv1}^{{-1}}\left({arg1_tex}\right) \text{{ and }} \beta = \{inv2}^{{-1}}\left({arg2_tex}\right)."
        step2 = rf"\text{{Based on principal domains, }} \alpha \text{{ is in Quadrant }} {quad_a} \text{{ and }} \beta \text{{ is in Quadrant }} {quad_b}."
        
        step3 = r"\text{Using the reference triangles, we identify the sides:}"
        step4 = rf"\text{{For }} \alpha: x = {x1}, \quad y = {y1}, \quad r = {r1}"
        step5 = rf"\text{{For }} \beta: x = {x2}, \quad y = {y2}, \quad r = {r2}"
        
        step6 = r"\text{Evaluate the fundamental trigonometric ratios:}"
        step7 = rf"\sin(\alpha) = {format_math(sin_a)}, \quad \cos(\alpha) = {format_math(cos_a)}"
        step8 = rf"\sin(\beta) = {format_math(sin_b)}, \quad \cos(\beta) = {format_math(cos_b)}"
        
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