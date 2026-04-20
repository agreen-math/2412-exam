from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Force magnitudes
        F1 = random.randint(1200, 1600)
        F2 = random.randint(1400, 1800)

        # Angle between the forces (degrees)
        theta = random.choice([20, 30, 40, 45, 60])

        # Resultant magnitude (Law of Cosines)
        R = sqrt(F1**2 + F2**2 + 2*F1*F2*cos(theta*pi/180))

        # Angle between resultant and F1 (Law of Sines)
        phi_resultant = arcsin(F2*sin(theta*pi/180)/R) * 180/pi

        # Format solutions mathematically to adhere to the Zero-Text Rule
        R_val = round(float(R), 1)
        phi_val = round(float(phi_resultant), 1)

        step1 = rf"(a) \quad \text{{Magnitude}} \approx {R_val} \text{{ lb}}"
        step2 = rf"(b) \quad \text{{Angle}} \approx {phi_val}^\circ"

        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{step2}</m></p>\n"
            f"</outtro>"
        )

        return {
            "F1": F1,
            "F2": F2,
            "theta": theta,
            "outtro": outtro
        }