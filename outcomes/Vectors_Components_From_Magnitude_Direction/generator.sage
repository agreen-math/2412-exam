from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        r = round(random.uniform(5.0, 15.0), 2)
        theta = random.randint(20, 340)

        x = r * cos(theta * pi / 180)
        y = r * sin(theta * pi / 180)

        # Format solutions mathematically to adhere to the Zero-Text Rule
        x_val = round(float(x), 2)
        y_val = round(float(y), 2)

        step1 = rf"(a) \quad \text{{Horizontal component}} \approx {x_val}, \quad \text{{Vertical component}} \approx {y_val}"
        step2 = rf"(b) \quad \text{{Vector}} \approx \langle {x_val}, {y_val} \rangle"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "r": r,
            "theta": theta,
            "outtro": outtro
        }