from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Define variable u and assume it's positive so radicals simplify cleanly
        u = var('u')
        assume(u > 0)

        k = random.choice([1, 2, 3, 4, 5])
        # Restrict c to positive integers to keep the reference triangle strictly in Q1
        allowed_c = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 24, 25, 30]
        c = Integer(random.choice(allowed_c))

        form = random.choice(["ku", "ku_over_c", "c_over_ku"])
        outer = random.choice(["sin", "cos"])
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        # Manually extract numerators and denominators to prevent SageMath 
        # from factoring out the coefficients (e.g., turning u/5 into 1/5 * u)
        if form == "ku":
            num_expr = k * u
            den_expr = SR(1)
            num_tex = rf"{'' if k==1 else k}u"
            den_tex = "1"
            arg_tex = num_tex
        elif form == "ku_over_c":
            num_expr = k * u
            den_expr = SR(c)
            num_tex = rf"{'' if k==1 else k}u"
            den_tex = str(c)
            arg_tex = rf"\frac{{{num_tex}}}{{{den_tex}}}"
        else:  # c_over_ku
            num_expr = SR(c)
            den_expr = k * u
            num_tex = str(c)
            den_tex = rf"{'' if k==1 else k}u"
            arg_tex = rf"\frac{{{num_tex}}}{{{den_tex}}}"

        # Build expression for the prompt
        expression_tex = rf"\{outer}\left(2\{inv}^{{-1}}\left({arg_tex}\right)\right)"

        # Explicitly map the numerator and denominator to x, y, and r
        if inv == "sin":
            y = num_expr; y_tex = num_tex
            r = den_expr; r_tex = den_tex
            x = sqrt(r**2 - y**2)
            x_tex = latex(x)
        elif inv == "cos":
            x = num_expr; x_tex = num_tex
            r = den_expr; r_tex = den_tex
            y = sqrt(r**2 - x**2)
            y_tex = latex(y)
        elif inv == "tan":
            y = num_expr; y_tex = num_tex
            x = den_expr; x_tex = den_tex
            r = sqrt(x**2 + y**2)
            r_tex = latex(r)
        elif inv == "csc":
            r = num_expr; r_tex = num_tex
            y = den_expr; y_tex = den_tex
            x = sqrt(r**2 - y**2)
            x_tex = latex(x)
        elif inv == "sec":
            r = num_expr; r_tex = num_tex
            x = den_expr; x_tex = den_tex
            y = sqrt(r**2 - x**2)
            y_tex = latex(y)
        else:  # cot
            x = num_expr; x_tex = num_tex
            y = den_expr; y_tex = den_tex
            r = sqrt(x**2 + y**2)
            r_tex = latex(r)

        # True mathematical ratios for calculation
        sin_a = y / r
        cos_a = x / r

        # Custom formatted LaTeX ratios for the display
        sin_a_tex = rf"\frac{{{y_tex}}}{{{r_tex}}}" if r_tex != "1" else y_tex
        cos_a_tex = rf"\frac{{{x_tex}}}{{{r_tex}}}" if r_tex != "1" else x_tex

        # Apply double angle identities and let SageMath simplify algebraically
        if outer == "sin":
            identity = r"\sin(2\alpha) = 2\sin(\alpha)\cos(\alpha)"
            plug_tex = rf"2\left({sin_a_tex}\right)\left({cos_a_tex}\right)"
            ans = (2 * sin_a * cos_a).simplify_full()
        else:
            if inv in ["cos", "sec"]:
                identity = r"\cos(2\alpha) = 2\cos^2(\alpha) - 1"
                plug_tex = rf"2\left({cos_a_tex}\right)^2 - 1"
                ans = (2 * cos_a**2 - 1).simplify_full()
            else:
                identity = r"\cos(2\alpha) = 1 - 2\sin^2(\alpha)"
                plug_tex = rf"1 - 2\left({sin_a_tex}\right)^2"
                ans = (1 - 2 * sin_a**2).simplify_full()

        # Helper to force the final answer to render as \frac{num}{den}
        def format_final(expr):
            num = expr.numerator()
            den = expr.denominator()
            if den == 1:
                return latex(num)
            
            num_str = latex(num)
            den_str = latex(den)
            # Safely extract negatives to the front of the fraction
            if num_str.startswith("-"):
                return rf"-\frac{{{num_str[1:]}}}{{{den_str}}}"
            return rf"\frac{{{num_str}}}{{{den_str}}}"

        ans_tex = format_final(ans)

        # --- Build the Step-by-Step Solution ---
        step1 = rf"\text{{Let }} \alpha = \{inv}^{{-1}}\left({arg_tex}\right)."
        step2 = r"\text{Using the reference triangle, we define the sides based on the inverse function:}"
        step3 = rf"x = {x_tex}, \quad y = {y_tex}, \quad r = {r_tex}"
        
        step4 = r"\text{From this, we write the required trigonometric ratios:}"
        step5 = rf"\sin(\alpha) = {sin_a_tex}"
        step6 = rf"\cos(\alpha) = {cos_a_tex}"
        
        step7 = r"\text{Apply the double-angle identity:}"
        step8 = rf"\{outer}(2\alpha) = {identity}"
        step9 = rf"\{outer}(2\alpha) = {plug_tex}"
        
        step10 = r"\text{Simplify the algebraic expression:}"
        step11 = rf"\{outer}(2\alpha) = {ans_tex}"

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
            f"    <p><m>{step11}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        # Clear assumptions so it doesn't pollute the next generation cycle
        forget(u > 0)

        return {
            "expression_tex": expression_tex,
            "solution_steps": solution_steps
        }