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

        # Format variables using latex() so the radicals render beautifully
        prompt_u = rf"\langle {ux}, {uy} \rangle"
        prompt_v = rf"\langle {latex(vx)}, {vy} \rangle"
        w_tex = rf"\langle {latex(w[0])}, {w[1]} \rangle"

        # Format solutions mathematically to adhere to the Zero-Text Rule
        step_a = rf"(a) \quad 2\mathbf{{u}} + \mathbf{{v}} = {w_tex}"
        step_b = rf"(b) \quad \|2\mathbf{{u}} + \mathbf{{v}}\| \approx {round(float(mag_w), 1)}"
        step_c = rf"(c) \quad \text{{Direction angle}} \approx {round(float(theta_w), 1)}^\circ"
        step_d = rf"(d) \quad \text{{Angle between the vectors}} \approx {round(float(phi), 1)}^\circ"

        outtro_lines = [
            f"    <p><m>{step_a}</m></p>",
            f"    <p><m>{step_b}</m></p>",
            f"    <p><m>{step_c}</m></p>",
            f"    <p><m>{step_d}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "u_tex": prompt_u,
            "v_tex": prompt_v,
            "outtro": outtro
        }