from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        for _ in range(1000):
            primary = random.choice(["sin", "cos"])
            secondary = random.choice(["sin", "cos", "tan", "sec", "csc", "cot"])

            # Standard Pythagorean triples to guarantee clean rational numbers
            triples = [(3, 4, 5), 
            (5, 12, 13)#, 
#            (8, 15, 17), 
#            (7, 24, 25)
            ]
            u, v, w = random.choice(triples)
            
            leg1 = random.choice([u, v])
            leg2 = v if leg1 == u else u
            sign = random.choice([1, -1])

            # Construct ratio based on the secondary function definition
            if secondary in ["sin", "cos"]:
                r = sign * QQ(leg1) / QQ(w)
            elif secondary in ["tan", "cot"]:
                r = sign * QQ(leg1) / QQ(leg2)
            else: # sec, csc
                r = sign * QQ(w) / QQ(leg1)

            r_num = RR(r)

            # Compute the angle theta
            if secondary == "sin": theta = asin(r)
            elif secondary == "cos": theta = acos(r)
            elif secondary == "tan": theta = atan(r)
            elif secondary == "cot": theta = acot(r)
            elif secondary == "sec": theta = asec(r)
            elif secondary == "csc": theta = acsc(r)

            # CRITICAL DOMAIN CHECK:
            # The equation requires 2*theta to be within the principal range of the Primary inverse function!
            theta_num = RR(theta)
            two_theta = 2 * theta_num

            if primary == "sin":
                if not (-RR(pi)/2 - 1e-6 <= two_theta <= RR(pi)/2 + 1e-6):
                    continue
            else: # primary == "cos"
                if not (-1e-6 <= two_theta <= RR(pi) + 1e-6):
                    continue

            # Calculate the final x value
            if primary == "sin":
                ans = SR(sin(2*theta)).simplify_full()
            else:
                ans = SR(cos(2*theta)).simplify_full()

            # Format the math beautifully
            primary_tex = rf"\{primary}^{{-1}}"
            secondary_tex = rf"\{secondary}^{{-1}}"
            r_tex = latex(r)

            # Randomize the equation structure
            eq_type = random.choice([1, 2, 3])
            if eq_type == 1:
                equation = rf"{primary_tex}(x) = 2 {secondary_tex}\left({r_tex}\right)"
            elif eq_type == 2:
                equation = rf"{primary_tex}(x) - {secondary_tex}\left({r_tex}\right) = {secondary_tex}\left({r_tex}\right)"
            else:
                equation = rf"{secondary_tex}\left({r_tex}\right) = {primary_tex}(x) - {secondary_tex}\left({r_tex}\right)"

            # --- Build the Step-by-Step Solution ---
            step1a = rf"{primary_tex}(x) = 2 {secondary_tex}\left({r_tex}\right)"
            step1b = rf"x = \{primary}\left(2 {secondary_tex}\left({r_tex}\right)\right)"

            step2a = rf"\text{{Let }} \theta = {secondary_tex}\left({r_tex}\right), \text{{ so }} \{secondary}(\theta) = {r_tex}."
            step2b = rf"\text{{Then }} x = \{primary}(2\theta)."

            # Evaluate the individual pieces for the double angle formulas
            sin_t = SR(sin(theta)).simplify_full()
            cos_t = SR(cos(theta)).simplify_full()

            if primary == "sin":
                step3a = r"x = \sin(2\theta) = 2\sin(\theta)\cos(\theta)"
                step3b = rf"x = 2\left({latex(sin_t)}\right)\left({latex(cos_t)}\right) = {latex(ans)}"
            else:
                step3a = r"x = \cos(2\theta) = 2\cos^2(\theta) - 1"
                step3b = rf"x = 2\left({latex(cos_t)}\right)^2 - 1 = {latex(ans)}"

            outtro_lines = [
                f"    <p><m>{step1a}</m></p>",
                f"    <p><m>{step1b}</m></p>",
                f"    <p><m>{step2a}</m></p>",
                f"    <p><m>{step2b}</m></p>",
                f"    <p><m>{step3a}</m></p>",
                f"    <p><m>{step3b}</m></p>"
            ]
            
            solution_steps = "\n".join(outtro_lines)

            return {
                "equation": equation,
                "solution_steps": solution_steps
            }

        raise RuntimeError("Failed to generate a valid problem within 1000 attempts.")