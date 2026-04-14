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
        R = sqrt(F1^2 + F2^2 + 2*F1*F2*cos(theta*pi/180))

        # Angle between resultant and F1 (Law of Sines)
        phi = arcsin(F2*sin(theta*pi/180)/R) * 180/pi

        return {
            "F1": F1,
            "F2": F2,
            "theta": theta,
            "R": round(float(R), 1),
            "phi": round(float(phi), 1)
        }