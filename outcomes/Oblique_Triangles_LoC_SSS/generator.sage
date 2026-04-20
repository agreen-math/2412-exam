from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate side lengths that always satisfy the triangle inequality
        a = round(random.uniform(6.0, 12.0), 2)
        b = round(random.uniform(7.0, 13.0), 2)

        # Ensure c < a + b
        c = round(random.uniform(abs(a - b) + 1.0, a + b - 1.0), 2)

        # Law of Cosines to find angle C
        cosC = (a^2 + b^2 - c^2) / (2 * a * b)
        C = arccos(cosC) * 180 / pi

        # Law of Sines (or Cosines) to find remaining angles
        cosA = (b^2 + c^2 - a^2) / (2 * b * c)
        A = arccos(cosA) * 180 / pi

        B = 180 - A - C

        # Format solutions mathematically to adhere to the Zero-Text Rule
        step1 = rf"\angle A \approx {round(float(A), 1)}^\circ"
        step2 = rf"\angle B \approx {round(float(B), 1)}^\circ"
        step3 = rf"\angle C \approx {round(float(C), 1)}^\circ"

        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{step2}</m></p>\n"
            f"    <p><m>{step3}</m></p>\n"
            f"</outtro>"
        )

        return {
            "a": a,
            "b": b,
            "c": c,
            "outtro": outtro
        }