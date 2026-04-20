from sage.all import *

class Generator(BaseGenerator):
    def data(self):
        # Use Sage RNG helpers so set_random_seed(seed) controls all randomness.
        input_type = choice([1, 2])

        if input_type == 1:
            triples = [
                (3, 4, 5),
                (5, 12, 13),
                (7, 24, 25),
                (8, 15, 17)
            ]
            a, b, r = choice(triples)
            # Randomly place the point in any of the four quadrants.
            x = choice([-1, 1]) * a
            y = choice([-1, 1]) * b
            hyp = r
        else:
            options = [
                (3, sqrt(7)),
                (4, sqrt(5)),
                (5, sqrt(11)),
                (2, sqrt(13)),
                (sqrt(3), 5)
            ]
            a, b = choice(options)
            x = choice([-1, 1]) * a
            y = choice([-1, 1]) * b
            hyp = sqrt(a**2 + b**2)

        # All six trig function values
        trig_vals = {
            "sin": y / hyp,
            "cos": x / hyp,
            "tan": y / x,
            "csc": hyp / y,
            "sec": hyp / x,
            "cot": x / y
        }

        # LaTeX names for each trig function
        trig_names = {
            "sin": r"\sin\theta",
            "cos": r"\cos\theta",
            "tan": r"\tan\theta",
            "csc": r"\csc\theta",
            "sec": r"\sec\theta",
            "cot": r"\cot\theta"
        }

        # Pick two distinct functions
        f1, f2 = sample(list(trig_vals.keys()), 2)

        # Safely simplify by casting to the Symbolic Ring (SR) first
        v1 = SR(trig_vals[f1]).simplify_full()
        v2 = SR(trig_vals[f2]).simplify_full()

        x_tex = latex(x)
        y_tex = latex(y)

        # Build the outtro to adhere to the Zero-Text Rule
        outtro_lines = [
            f"    <p>Using the reference triangle with the point <m>({x_tex}, {y_tex})</m>:</p>",
            f"    <p><m>{trig_names[f1]} = {latex(v1)}</m></p>",
            f"    <p><m>{trig_names[f2]} = {latex(v2)}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "x_coord": x_tex,
            "y_coord": y_tex,
            "expr1": trig_names[f1],
            "expr2": trig_names[f2],
            "outtro": outtro
        }