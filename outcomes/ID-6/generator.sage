from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Helper to cleanly format radicals as \frac{\sqrt{a}}{b} instead of \frac{1}{b}\sqrt{a}
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

        # 1. Pick initial function and a rational ratio
        f1 = random.choice(["sin", "cos", "tan"])
        
        b = random.randint(3, 9)
        if f1 in ["sin", "cos"]:
            # Guarantee the ratio is < 1 for sine and cosine
            a = random.randint(1, b - 1)
        else: 
            # Tangent can be anything, but avoid exactly 1 to prevent undefined tan(2x)
            a = random.randint(1, 9)
            while a == b:
                a = random.randint(1, 9)
                
        sign = random.choice([1, -1])
        val = sign * Integer(a) / Integer(b)
        
        # 2. Determine Valid Quadrants
        if f1 == "sin":
            valid_quads = [1, 2] if sign == 1 else [3, 4]
        elif f1 == "cos":
            valid_quads = [1, 4] if sign == 1 else [2, 3]
        else: # tan
            valid_quads = [1, 3] if sign == 1 else [2, 4]
            
        quad = random.choice(valid_quads)
        
        # Map quadrant to radian inequalities using \lt to avoid XML parsing crashes
        bounds = {
            1: r"0 \lt \theta \lt \frac{\pi}{2}",
            2: r"\frac{\pi}{2} \lt \theta \lt \pi",
            3: r"\pi \lt \theta \lt \frac{3\pi}{2}",
            4: r"\frac{3\pi}{2} \lt \theta \lt 2\pi"
        }
        bound_tex = bounds[quad]
        
        # 3. Build the Reference Triangle
        if f1 == "sin":
            y_mag = a; r_val = b
            x_mag = SR(sqrt(b**2 - a**2))
        elif f1 == "cos":
            x_mag = a; r_val = b
            y_mag = SR(sqrt(b**2 - a**2))
        else: # tan
            y_mag = a; x_mag = b
            r_val = SR(sqrt(a**2 + b**2))
            
        # Apply strict quadrant signs
        x_val = x_mag if quad in [1, 4] else -x_mag
        y_val = y_mag if quad in [1, 2] else -y_mag
        
        # Calculate ALL fundamental trig values using SR to prevent decimal conversion
        sin_t = (SR(y_val) / SR(r_val)).simplify_full()
        cos_t = (SR(x_val) / SR(r_val)).simplify_full()
        tan_t = (SR(y_val) / SR(x_val)).simplify_full()
        
        # Apply the new formatter so intermediate steps look beautiful
        sin_t_tex = format_math(sin_t)
        cos_t_tex = format_math(cos_t)
        tan_t_tex = format_math(tan_t)
        
        # 4. Target Double-Angle Functions (Pick 2 distinct functions)
        f2_a, f2_b = random.sample(["sin", "cos", "tan"], 2)
        
        # Helper function to generate the specific math for the chosen function
        def get_double_angle(f2):
            if f2 == "sin":
                ans = 2 * sin_t * cos_t
                form_tex = r"\sin(2\theta) = 2\sin\theta\cos\theta"
                sub_tex = rf"\sin(2\theta) = 2\left({sin_t_tex}\right)\left({cos_t_tex}\right)"
            elif f2 == "cos":
                ans = cos_t**2 - sin_t**2
                form_tex = r"\cos(2\theta) = \cos^2\theta - \sin^2\theta"
                sub_tex = rf"\cos(2\theta) = \left({cos_t_tex}\right)^2 - \left({sin_t_tex}\right)^2"
            else:
                ans = (2 * tan_t) / (1 - tan_t**2)
                form_tex = r"\tan(2\theta) = \frac{2\tan\theta}{1 - \tan^2\theta}"
                sub_tex = rf"\tan(2\theta) = \frac{{2\left({tan_t_tex}\right)}}{{1 - \left({tan_t_tex}\right)^2}}"
            
            # Safely cast to SR and simplify
            return SR(ans).simplify_full(), form_tex, sub_tex

        ans_a, form_a, sub_a = get_double_angle(f2_a)
        ans_b, form_b, sub_b = get_double_angle(f2_b)
        
        ans_a_tex = format_math(ans_a)
        ans_b_tex = format_math(ans_b)
        
        # 5. Format Variables for the XML
        f1_tex = rf"\{f1}\theta"
        f2a_tex = rf"\{f2_a}(2\theta)"
        f2b_tex = rf"\{f2_b}(2\theta)"
        val_tex = latex(val)
        
        # --- Build the Step-by-Step Solution ---
        step1 = r"\text{Step 1: Identify Quadrant and Signs}"
        step2 = rf"\text{{Since }} {f1_tex} = {val_tex} \text{{ and }} {bound_tex}, \text{{ the angle is in Quadrant }} {quad}."
        
        if f1 == "sin":
            step3 = rf"\text{{We know }} y = {latex(y_val)} \text{{ and }} r = {r_val}. \text{{ Find }} x:"
            step4 = rf"x^2 + y^2 = r^2 \implies x = \pm\sqrt{{{r_val}^2 - ({latex(y_mag)})^2}} = {latex(x_val)} \quad \text{{(negative in Q2/Q3, positive in Q1/Q4)}}"
        elif f1 == "cos":
            step3 = rf"\text{{We know }} x = {latex(x_val)} \text{{ and }} r = {r_val}. \text{{ Find }} y:"
            step4 = rf"x^2 + y^2 = r^2 \implies y = \pm\sqrt{{{r_val}^2 - ({latex(x_mag)})^2}} = {latex(y_val)} \quad \text{{(positive in Q1/Q2, negative in Q3/Q4)}}"
        else:
            step3 = rf"\text{{We know }} y = {latex(y_val)} \text{{ and }} x = {latex(x_val)}. \text{{ Find }} r:"
            step4 = rf"r = \sqrt{{x^2 + y^2}} = \sqrt{{({latex(x_val)})^2 + ({latex(y_val)})^2}} = {latex(r_val)}"

        step5 = r"\text{Step 2: Evaluate required fundamental trigonometric functions}"
        step6 = rf"\sin\theta = {sin_t_tex}, \quad \cos\theta = {cos_t_tex}, \quad \tan\theta = {tan_t_tex}"
            
        step7 = r"\text{Step 3: Apply the double-angle formulas}"
        
        # Part A
        step8 = rf"\text{{(a) Find }} {f2a_tex}:"
        step9 = form_a
        step10 = sub_a
        step11 = rf"{f2a_tex} = {ans_a_tex}"
        
        # Part B
        step12 = rf"\text{{(b) Find }} {f2b_tex}:"
        step13 = form_b
        step14 = sub_b
        step15 = rf"{f2b_tex} = {ans_b_tex}"
        
        outtro_lines = [
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
            f"    <p><m>{step12}</m></p>",
            f"    <p><m>{step13}</m></p>",
            f"    <p><m>{step14}</m></p>",
            f"    <p><m>{step15}</m></p>"
        ]
        
        solution_steps = "\n".join(outtro_lines)
        
        return {
            "f1_tex": f1_tex,
            "val_tex": val_tex,
            "bound_tex": bound_tex,
            "f2a_tex": f2a_tex,
            "f2b_tex": f2b_tex,
            "solution_steps": solution_steps
        }