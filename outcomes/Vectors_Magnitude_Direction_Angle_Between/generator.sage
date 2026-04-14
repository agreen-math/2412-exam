from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate two nonzero vectors u and v
        ux = random.randint(2, 6)
        uy = random.randint(-5, 5)
        vx = random.choice([sqrt(2), sqrt(3), sqrt(5)])
        vy = random.randint(-8, -2)

        # Define vectors
        u = vector([ux, uy])
        v = vector([vx, vy])

        # Linear combination
        w = 2*u + v

        # Magnitude of w
        mag_w = sqrt(w.dot_product(w))

        # Direction angle of w (in degrees, [0,360))
        theta_w = atan2(w[1], w[0]) * 180 / pi
        if theta_w < 0:
            theta_w += 360

        # Angle between u and v
        cos_phi = (u.dot_product(v)) / (sqrt(u.dot_product(u)) * sqrt(v.dot_product(v)))
        phi = arccos(cos_phi) * 180 / pi

        return {
            "ux": ux,
            "uy": uy,
            "vx": vx,
            "vy": vy,

            "wx": w[0],
            "wy": w[1],

            "mag_w": round(float(mag_w), 1),
            "theta_w": round(float(theta_w), 1),
            "phi": round(float(phi), 1)
        }
