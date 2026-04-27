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

        outer = random.choice(["sin", "cos"])
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        # Create "messier" number pools for practice
        # Skip 1, 0, and -1 to avoid trivial arithmetic
        pos_pool = list(range(2, 21))
        all_pool = list(range(-20, -1)) + list(range(2, 21))

        # CRITICAL DOMAIN ENFORCEMENT FIX
        # sin^-1, tan^-1, csc^-1 have outputs in Q1 or Q4 (meaning x is always positive)
        if inv in ["sin", "tan", "csc"]:
            x_val = random.choice(pos_pool)
            y_val = random.choice(all_pool)
        # cos^-1, sec^-1, cot^-1 have outputs in Q1 or Q2 (meaning y is always positive)
        else:
            y_val = random.choice(pos_pool)
            x_val = random.choice(all_pool)

        # Calculate precise symbolic radius
        r_val = SR(sqrt(x_val**2 + y_val**2))

        # Define mathematical ratios securely
        sin_a = SR(y_val) / r_val
        cos_a = SR(x_val) / r_val

        # Determine the exact argument given to the inverse function
        if inv == "sin": arg = sin_a
        elif inv == "cos": arg = cos_a
        elif inv == "tan": arg = SR(y_val) / SR(x_val)
        elif inv == "csc": arg = r_val / SR(y_val)
        elif inv == "sec": arg = r_val / SR(x_val)
        else: arg = SR(x_val) / SR(y_val) # cot

        arg_tex = format_math(arg)
        expression = rf"\{outer}\left(2\{inv}^{{-1}}\left({arg_tex}\right)\right)"

        # Apply double angle identities and evaluate using Symbolic Ring
        if outer == "sin":
            identity = r"\sin(2\alpha) = 2\sin(\alpha)\cos(\alpha)"
            plug_tex = rf"2\left({format_math(sin_a)}\right)\left({format_math(cos_a)}\right)"
            ans = (2 * sin_a * cos_a).simplify_full()
        else: # cos
            identity = r"\cos(2\alpha) = \cos^2(\alpha) - \sin^2(\alpha)"
            plug_tex = rf"\left({format_math(cos_a)}\right)^2 - \left({format_math(sin_a)}\right)^2"
            ans = (cos_a**2 - sin_a**2).simplify_full()

        ans_tex = format_math(ans)

        # Determine quadrant text based on x and y signs
        quadrant = "I" if (x_val > 0 and y_val > 0) else "II" if (x_val < 0) else "IV"

        # --- Build the Step-by-Step Solution ---
        step1 = rf"\text{{Let }} \alpha = \{inv}^{{-1}}\left({arg_tex}\right)."
        step2 = rf"\text{{Based on the domain of }} \{inv}^{{-1}} \text{{ and the sign of the argument, }} \alpha \text{{ is in Quadrant }} {quadrant}."
        step3 = rf"\text{{Using the reference triangle, we identify: }} x = {x_val}, \quad y = {y_val}, \quad r = {latex(r_val)}"
        step4 = r"\text{Evaluate the fundamental trigonometric ratios:}"
        step5 = rf"\sin(\alpha) = {format_math(sin_a)}, \quad \cos(\alpha) = {format_math(cos_a)}"
        step6 = r"\text{Apply the double-angle identity:}"
        step7 = rf"\{outer}(2\alpha) = {identity}"
        step8 = rf"\{outer}(2\alpha) = {plug_tex}"
        step9 = rf"\{outer}(2\alpha) = {ans_tex}"

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
            f"    <p><m>{step9}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "expression": expression,
            "solution_steps": solution_steps
        }