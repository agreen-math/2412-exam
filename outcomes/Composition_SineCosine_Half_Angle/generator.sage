from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Helper to cleanly format radicals and fractions, safe for nested radicals
        def format_math(expr):
            expr = SR(expr).simplify_full()
            if expr in QQ:
                return latex(expr)
            try:
                num = expr.numerator()
                den = expr.denominator()
                if den != 1:
                    # Safely handle negatives to put the minus sign outside the fraction
                    if bool(expr < 0):
                        return rf"-\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"
                    else:
                        return rf"\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"
            except:
                pass
            return latex(expr)

        outer = random.choice(["sin", "cos", "tan"])
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        # Completely random integer pools to force nested radicals
        # Skip 1, 0, and -1 to avoid trivial arithmetic
        pos_pool = list(range(2, 15))
        all_pool = list(range(-15, -1)) + list(range(2, 15))

        # CRITICAL DOMAIN ENFORCEMENT
        # sin^-1, tan^-1, csc^-1 have outputs in Q1 or Q4 (meaning x is always positive)
        if inv in ["sin", "tan", "csc"]:
            x_val = random.choice(pos_pool)
            y_val = random.choice(all_pool)
        # cos^-1, sec^-1, cot^-1 have outputs in Q1 or Q2 (meaning y is always positive)
        else:
            y_val = random.choice(pos_pool)
            x_val = random.choice(all_pool)

        # Calculate symbolic radius (this will often be an irrational radical now)
        r_val = SR(sqrt(x_val**2 + y_val**2)).simplify_full()

        # Define mathematical ratios securely
        sin_a = SR(y_val) / SR(r_val)
        cos_a = SR(x_val) / SR(r_val)

        # Determine the exact argument given to the inverse function
        if inv == "sin": arg = sin_a
        elif inv == "cos": arg = cos_a
        elif inv == "tan": arg = SR(y_val) / SR(x_val)
        elif inv == "csc": arg = SR(r_val) / SR(y_val)
        elif inv == "sec": arg = SR(r_val) / SR(x_val)
        else: arg = SR(x_val) / SR(y_val) # cot

        arg_tex = format_math(arg)
        expression = rf"\{outer}\left(\frac{{1}}{{2}}\{inv}^{{-1}}\left({arg_tex}\right)\right)"

        # Determine quadrants and the resulting signs for the half-angle
        if x_val > 0 and y_val > 0:
            quad_a = "I"
            quad_half = "I"
            sin_half_sign = 1
            cos_half_sign = 1
        elif x_val < 0 and y_val > 0:
            quad_a = "II"
            quad_half = "I"
            sin_half_sign = 1
            cos_half_sign = 1
        else: # x_val > 0 and y_val < 0
            quad_a = "IV"
            # If alpha is in Q4 (-90 to 0), alpha/2 is in Q4 (-45 to 0)
            quad_half = "IV"
            sin_half_sign = -1
            cos_half_sign = 1

        # Apply half-angle identities and let SageMath handle the nested radicals
        if outer == "sin":
            ans = sin_half_sign * sqrt((1 - cos_a) / 2)
            identity = r"\sin\left(\frac{\alpha}{2}\right) = \pm\sqrt{\frac{1-\cos(\alpha)}{2}}"
            sign_str = "-" if sin_half_sign == -1 else "+"
            plug_tex = rf"{sign_str}\sqrt{{\frac{{1 - \left({format_math(cos_a)}\right)}}{{2}}}}"
        elif outer == "cos":
            ans = cos_half_sign * sqrt((1 + cos_a) / 2)
            identity = r"\cos\left(\frac{\alpha}{2}\right) = \pm\sqrt{\frac{1+\cos(\alpha)}{2}}"
            sign_str = "+" # Always positive based on principal domains
            plug_tex = rf"{sign_str}\sqrt{{\frac{{1 + \left({format_math(cos_a)}\right)}}{{2}}}}"
        else: # tan (using the safe identity that avoids nested radicals entirely!)
            ans = (1 - cos_a) / sin_a
            identity = r"\tan\left(\frac{\alpha}{2}\right) = \frac{1-\cos(\alpha)}{\sin(\alpha)}"
            plug_tex = rf"\frac{{1 - \left({format_math(cos_a)}\right)}}{{{format_math(sin_a)}}}"

        ans_tex = format_math(ans)

        # --- Build the Step-by-Step Solution ---
        step1 = rf"\text{{Let }} \alpha = \{inv}^{{-1}}\left({arg_tex}\right)."
        step2 = rf"\text{{Based on the domain of }} \{inv}^{{-1}} \text{{ and the argument, }} \alpha \text{{ is in Quadrant }} {quad_a}."
        step3 = rf"\text{{Therefore, the half-angle }} \frac{{\alpha}}{{2}} \text{{ must be in Quadrant }} {quad_half}."
        step4 = rf"\text{{Using the reference triangle, we identify: }} x = {x_val}, \quad y = {y_val}, \quad r = {latex(r_val)}"
        step5 = r"\text{Evaluate the required fundamental trigonometric ratios:}"
        step6 = rf"\sin(\alpha) = {format_math(sin_a)}, \quad \cos(\alpha) = {format_math(cos_a)}"
        step7 = r"\text{Apply the half-angle identity (choosing the sign based on the half-angle quadrant):}"
        step8 = rf"\{outer}\left(\frac{{\alpha}}{{2}}\right) = {identity}"
        step9 = rf"\{outer}\left(\frac{{\alpha}}{{2}}\right) = {plug_tex}"
        step10 = rf"\{outer}\left(\frac{{\alpha}}{{2}}\right) = {ans_tex}"

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
            f"    <p><m>{step10}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "expression": expression,
            "solution_steps": solution_steps
        }