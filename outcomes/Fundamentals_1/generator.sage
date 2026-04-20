from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Unit-circle angles:
        # (degrees, radians, radians_latex)
        angles = [
            (0, 0, r"0"),
            (30, pi/6, r"\frac{\pi}{6}"),
            (45, pi/4, r"\frac{\pi}{4}"),
            (60, pi/3, r"\frac{\pi}{3}"),
            (90, pi/2, r"\frac{\pi}{2}"),
            (120, 2*pi/3, r"\frac{2\pi}{3}"),
            (135, 3*pi/4, r"\frac{3\pi}{4}"),
            (150, 5*pi/6, r"\frac{5\pi}{6}"),
            (180, pi, r"\pi"),
            (210, 7*pi/6, r"\frac{7\pi}{6}"),
            (225, 5*pi/4, r"\frac{5\pi}{4}"),
            (240, 4*pi/3, r"\frac{4\pi}{3}"),
            (270, 3*pi/2, r"\frac{3\pi}{2}"),
            (300, 5*pi/3, r"\frac{5\pi}{3}"),
            (315, 7*pi/4, r"\frac{7\pi}{4}"),
            (330, 11*pi/6, r"\frac{11\pi}{6}"),
        ]

        functions = ["sin", "cos", "tan", "sec", "csc", "cot"]

        # Canonical exact answers:
        # (symbolic value, latex string)
        canonical = [
            (0, r"0"),
            (1, r"1"),
            (-1, r"-1"),
            (sqrt(2)/2, r"\frac{\sqrt{2}}{2}"),
            (-sqrt(2)/2, r"-\frac{\sqrt{2}}{2}"),
            (sqrt(3)/2, r"\frac{\sqrt{3}}{2}"),
            (-sqrt(3)/2, r"-\frac{\sqrt{3}}{2}"),
            (sqrt(3), r"\sqrt{3}"),
            (-sqrt(3), r"-\sqrt{3}"),
            (sqrt(3)/3, r"\frac{\sqrt{3}}{3}"),
            (-sqrt(3)/3, r"-\frac{\sqrt{3}}{3}"),
            (2*sqrt(3)/3, r"\frac{2\sqrt{3}}{3}"),
            (-2*sqrt(3)/3, r"-\frac{2\sqrt{3}}{3}"),
        ]

        data = {}
        outtro_lines = []

        for i in range(1, 7):
            func = random.choice(functions)
            deg, rad, rad_tex = random.choice(angles)

            # Parts a-c: degrees; parts d-f: radians
            angle_tex = f"{deg}^\\circ" if i <= 3 else rad_tex

            try:
                val = {
                    "sin": sin(rad),
                    "cos": cos(rad),
                    "tan": tan(rad),
                    "sec": 1/cos(rad),
                    "csc": 1/sin(rad),
                    "cot": cos(rad)/sin(rad),
                }[func].simplify_full()

                answer = None
                for sym, tex in canonical:
                    if val == sym:
                        answer = tex
                        break

                if answer is None:
                    # Should never occur for unit-circle values
                    answer = latex(val)

            except ZeroDivisionError:
                answer = r"\text{undefined}"

            # Format the question and answer neatly
            prompt_tex = rf"\{func}\left({angle_tex}\right)"
            data[f"q{i}"] = prompt_tex
            
            letter = chr(96 + i) # dynamically gets a, b, c, d, e, f
            step = rf"({letter}) \quad {prompt_tex} = {answer}"
            outtro_lines.append(f"    <p><m>{step}</m></p>")

        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"
        data["outtro"] = outtro

        return data