from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # SSA ambiguous case: guaranteed two triangles
        A = random.randint(25, 40)  # acute angle
        b = round(random.uniform(10.0, 14.0), 2)

        # Force ambiguous case: b*sin(A) < a < b
        lower = b * sin(A * pi / 180)
        a = round(random.uniform(float(lower) + 0.5, b - 0.5), 2)

        # Law of Sines
        sinB = b * sin(A * pi / 180) / a

        B1 = asin(sinB) * 180 / pi
        B2 = 180 - B1

        C1 = 180 - A - B1
        C2 = 180 - A - B2

        c1 = a * sin(C1 * pi / 180) / sin(A * pi / 180)
        c2 = a * sin(C2 * pi / 180) / sin(A * pi / 180)

        # Format solutions mathematically to adhere to the Zero-Text Rule
        step1 = rf"B_1 \approx {round(float(B1), 1)}^\circ, \quad C_1 \approx {round(float(C1), 1)}^\circ, \quad c_1 \approx {round(float(c1), 2)}"
        step2 = rf"B_2 \approx {round(float(B2), 1)}^\circ, \quad C_2 \approx {round(float(C2), 1)}^\circ, \quad c_2 \approx {round(float(c2), 2)}"

        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{step2}</m></p>\n"
            f"</outtro>"
        )

        return {
            "A": A,
            "a": a,
            "b": b,
            "outtro": outtro
        }