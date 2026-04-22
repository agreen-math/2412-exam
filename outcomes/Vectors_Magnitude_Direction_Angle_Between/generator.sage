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
        dot_uv = u.dot_product(v)
        mag_u = sqrt(u.dot_product(u))
        mag_v = sqrt(v.dot_product(v))
        
        cos_phi = dot_uv / (mag_u * mag_v)
        phi = arccos(cos_phi) * 180 / pi

        # Format variables using latex() so the radicals render beautifully
        prompt_u = rf"\langle {ux}, {uy} \rangle"
        prompt_v = rf"\langle {latex(vx)}, {vy} \rangle"
        w_tex = rf"\langle {latex(w[0])}, {w[1]} \rangle"

        # --- Step (a): Linear Combination ---
        step_a1 = rf"(a) \quad 2\mathbf{{u}} + \mathbf{{v}} = 2\langle {ux}, {uy} \rangle + \langle {latex(vx)}, {vy} \rangle"
        step_a2 = rf"\quad = \langle {2*ux}, {2*uy} \rangle + \langle {latex(vx)}, {vy} \rangle = {w_tex}"

        # --- Step (b): Magnitude ---
        step_b1 = rf"(b) \quad \|2\mathbf{{u}} + \mathbf{{v}}\| = \sqrt{{({latex(w[0])})^2 + ({w[1]})^2}}"
        step_b2 = rf"\quad \approx {round(float(mag_w), 1)}"

        # --- Step (c): Direction Angle ---
        step_c1 = rf"(c) \quad \text{{Direction angle}} = \tan^{{-1}}\left(\frac{{{w[1]}}}{{{latex(w[0])}}}\right)"
        step_c2 = rf"\quad \approx {round(float(theta_w), 1)}^\circ"

        # --- Step (d): Angle Between Vectors ---
        step_d1 = rf"(d) \quad \text{{Angle}} = \cos^{{-1}}\left(\frac{{\mathbf{{u}} \cdot \mathbf{{v}}}}{{\|\mathbf{{u}}\| \|\mathbf{{v}}\|}}\right)"
        step_d2 = rf"\quad = \cos^{{-1}}\left(\frac{{{latex(dot_uv)}}}{{{latex(mag_u)} \cdot {latex(mag_v)}}}\right) \approx {round(float(phi), 1)}^\circ"

        outtro_lines = [
            f"    <p><m>{step_a1}</m></p>",
            f"    <p><m>{step_a2}</m></p>",
            f"    <p><m>{step_b1}</m></p>",
            f"    <p><m>{step_b2}</m></p>",
            f"    <p><m>{step_c1}</m></p>",
            f"    <p><m>{step_c2}</m></p>",
            f"    <p><m>{step_d1}</m></p>",
            f"    <p><m>{step_d2}</m></p>"
        ]
        
        # We now only return the inner HTML blocks, not the <outtro> tags themselves
        solution_steps = "\n".join(outtro_lines)

        return {
            "u_tex": prompt_u,
            "v_tex": prompt_v,
            "solution_steps": solution_steps
        }