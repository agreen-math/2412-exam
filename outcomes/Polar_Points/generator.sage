import random

class Generator(BaseGenerator):
    def data(self):
        # Ensure exactly one quadrantal and one non-quadrantal angle
        is_quad = [True, False]
        random.shuffle(is_quad)
        
        # Ensure exactly one is in radians and one is in degrees
        is_rad = [True, False]
        random.shuffle(is_rad)
        
        # Select integer radii to fit the (-5, 5) grid
        r_vals = [choice([-5, -4, -3, -2, 2, 3, 4, 5]) for _ in range(2)]
        
        # Standard unit circle angle pools
        quad_rads = [0, pi/2, pi, 3*pi/2]
        quad_degs = [0, 90, 180, 270]
        nq_rads = [pi/6, pi/4, pi/3, 2*pi/3, 3*pi/4, 5*pi/6, 7*pi/6, 5*pi/4, 4*pi/3, 5*pi/3, 7*pi/4, 11*pi/6]
        nq_degs = [30, 45, 60, 120, 135, 150, 210, 225, 240, 300, 315, 330]
        
        pts = []
        rects = []
        theta_evals = []
        
        for i in range(2):
            if is_quad[i]:
                if is_rad[i]:
                    theta = choice(quad_rads)
                    theta_str = latex(theta)
                    theta_eval = theta
                else:
                    deg = choice(quad_degs)
                    theta_str = rf"{deg}^\circ"
                    theta_eval = deg * pi / 180
            else:
                if is_rad[i]:
                    theta = choice(nq_rads)
                    theta_str = latex(theta)
                    theta_eval = theta
                else:
                    deg = choice(nq_degs)
                    theta_str = rf"{deg}^\circ"
                    theta_eval = deg * pi / 180
            
            theta_evals.append(theta_eval)        
            r = r_vals[i]
            pts.append(rf"\left({r}, {theta_str}\right)")
            
            # Use exact radical arithmetic for rectangular answers
            x_coord = r * cos(theta_eval)
            y_coord = r * sin(theta_eval)
            rects.append(rf"\left({latex(x_coord)}, {latex(y_coord)}\right)")
            
        # Convert radian angles to numerical degrees for TikZ plotting
        deg_a = (theta_evals[0] * 180 / pi).n()
        deg_b = (theta_evals[1] * 180 / pi).n()
        
        # Construct the dynamic TikZ diagram inside a <latex-image> block
        # This will be converted to SVG for Web and remain TikZ for LaTeX export
        image_xml = (
            f"    <image>\n"
            f"      <latex-image>\n"
            f"        <![CDATA[\n"
            f"          \\begin{{tikzpicture}}[scale=0.6]\n"
            f"            \\draw[lightgray, very thin] (0,0) circle (1) circle (2) circle (3) circle (4) circle (5);\n"
            f"            \\foreach \\a in {{0,15,...,345}} \\draw[lightgray, very thin] (0,0) -- (\\a:5);\n"
            f"            \\draw[gray, thin] (0,0) circle (1) circle (2) circle (3) circle (4) circle (5);\n"
            f"            \\foreach \\a in {{0,30,...,330}} \\draw[gray, thin] (0,0) -- (\\a:5);\n"
            f"            \\draw[->, thick] (-5.5,0) -- (5.5,0) node[right] {{$x$}};\n"
            f"            \\draw[->, thick] (0,-5.5) -- (0,5.5) node[above] {{$y$}};\n"
            f"            \\fill[blue] ({deg_a}:{r_vals[0]}) circle (3pt) node[above right, blue, fill=white, inner sep=1pt, opacity=0.8, text opacity=1] {{A}};\n"
            f"            \\fill[red] ({deg_b}:{r_vals[1]}) circle (3pt) node[above right, red, fill=white, inner sep=1pt, opacity=0.8, text opacity=1] {{B}};\n"
            f"          \\end{{tikzpicture}}\n"
            f"        ]]>\n"
            f"      </latex-image>\n"
            f"    </image>"
        )
            
        # Adhering to the Zero-Text Rule for the <outtro>
        outtro = (
            f"<outtro>\n"
            f"{image_xml}\n"
            f"    <p><m>A: (x, y) = {rects[0]}</m></p>\n"
            f"    <p><m>B: (x, y) = {rects[1]}</m></p>\n"
            f"</outtro>"
        )

        return {
            "pt_a": pts[0],
            "pt_b": pts[1],
            "outtro": outtro
        }