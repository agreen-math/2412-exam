from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        def get_ratio():
            b = random.randint(5, 13)
            a = random.randint(1, b - 1)
            r = Integer(a) / Integer(b)
            while r in [0, Integer(1)/2, 1]:
                a = random.randint(1, b - 1)
                r = Integer(a) / Integer(b)
            return a, b, r

        f2 = random.choice(["sin", "cos"])
        f3 = random.choice(["sin", "cos"])

        a2, b2, r2 = get_ratio()
        a3, b3, r3 = get_ratio()

        funcs = {
            "sin": arcsin,
            "cos": arccos
        }

        alpha = funcs[f2](r2)
        beta = funcs[f3](r3)

        x_val = sin(alpha + beta).simplify()

        step1 = rf"x = \sin\left(\{f2}^{{-1}}\!\left(\frac{{{a2}}}{{{b2}}}\right) + \{f3}^{{-1}}\!\left(\frac{{{a3}}}{{{b3}}}\right)\right)"
        step2 = rf"x = \sin(\alpha + \beta)"
        final = rf"\boxed{{x = {latex(x_val)}}}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{final}</m></p>"
        ]

        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "f2": f2,
            "f3": f3,
            "a2": a2,
            "b2": b2,
            "a3": a3,
            "b3": b3,
            "outtro": outtro
        }
