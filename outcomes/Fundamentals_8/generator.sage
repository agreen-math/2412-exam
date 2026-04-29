from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Helper to cleanly format radicals and fractions, safely pulling negatives out front
        def format_math(expr):
            expr = SR(expr).simplify_full()
            if expr in QQ:
                return latex(expr)
            try:
                num = expr.numerator()
                den = expr.denominator()
                if den != 1:
                    if bool(expr < 0):
                        return rf"-\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"
                    else:
                        return rf"\frac{{{latex(abs(num))}}}{{{latex(abs(den))}}}"
            except:
                pass
            return latex(expr)

        input_type = random.choice([1, 2])

        if input_type == 1:
            # Pythagorean Triples
            triples = [(3, 4, 5), (5, 12, 13), (7, 24, 25), (8, 15, 17)]
            base_x, base_y, r_val = random.choice(triples)
        else:
            # Irrational coordinates
            options = [(3, sqrt(7)), (4, sqrt(5)), (5, sqrt(11)), (2, sqrt(13)), (sqrt(3), 5)]
            base_x, base_y = random.choice(options)
            r_val = SR(sqrt(base_x**2 + base_y**2)).simplify_full()

        # Randomly swap x and y to increase problem variety
        if random.choice([True, False]):
            base_x, base_y = base_y, base_x

        # Randomly assign quadrants
        x_val = random.choice([-1, 1]) * base_x
        y_val = random.choice([-1, 1]) * base_y
        r_val = SR(r_val)

        # Map the fundamental ratios securely
        trig_defs = {
            "sin": (y_val, r_val, r"\frac{y}{r}"),
            "cos": (x_val, r_val, r"\frac{x}{r}"),
            "tan": (y_val, x_val, r"\frac{y}{x}"),
            "csc": (r_val, y_val, r"\frac{r}{y}"),
            "sec": (r_val, x_val, r"\frac{r}{x}"),
            "cot": (x_val, y_val, r"\frac{x}{y}")
        }

        # Pick two distinct trigonometric functions to ask about
        funcs = ["sin", "cos", "tan", "csc", "sec", "cot"]
        f1, f2 = random.sample(funcs, 2)

        num1, den1, formula1 = trig_defs[f1]
        num2, den2, formula2 = trig_defs[f2]

        ans1 = SR(num1) / SR(den1)
        ans2 = SR(num2) / SR(den2)

        ans1_tex = format_math(ans1)
        ans2_tex = format_math(ans2)

        name1 = rf"\{f1}\theta"
        name2 = rf"\{f2}\theta"

        # --- Build Step-by-Step Solution ---
        step1 = rf"\text{{Given the point }} ({latex(x_val)}, {latex(y_val)})\text{{, we identify }} x = {latex(x_val)} \text{{ and }} y = {latex(y_val)}."
        step2 = r"r = \sqrt{x^2 + y^2}"
        step3 = rf"r = \sqrt{{\left({latex(x_val)}\right)^2 + \left({latex(y_val)}\right)^2}} = {latex(r_val)}"
        
        step4 = rf"{name1} = {formula1} = \frac{{{latex(num1)}}}{{{latex(den1)}}} = {ans1_tex}"
        step5 = rf"{name2} = {formula2} = \frac{{{latex(num2)}}}{{{latex(den2)}}} = {ans2_tex}"

        outtro_lines = [
            f"    <p><em>Solution:</em></p>",
            f"    <p><m>{step1}</m></p>",
            f"    <p>First, calculate the radius (hypotenuse) <m>r</m>:</p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p>Now apply the trigonometric ratios:</p>",
            f"    <p><m>{step4}</m></p>",
            f"    <p><m>{step5}</m></p>"
        ]

        return {
            "x_coord": latex(x_val),
            "y_coord": latex(y_val),
            "expr1": name1,
            "expr2": name2,
            "solution_steps": "\n".join(outtro_lines)
        }