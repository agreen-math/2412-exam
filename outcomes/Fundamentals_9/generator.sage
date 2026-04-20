from sage.all import *
import re

class Generator(BaseGenerator):
    def data(self):
        # Build the unit circle dynamically for all 6 trig functions
        # Stored as: (deg, rad, sin, cos, tan, csc, sec, cot)
        uc = []
        for deg, rad, s, c in [
            (0, 0, 0, 1),
            (30, pi/6, 1/2, sqrt(3)/2),
            (45, pi/4, sqrt(2)/2, sqrt(2)/2),
            (60, pi/3, sqrt(3)/2, 1/2),
            (90, pi/2, 1, 0),
            (120, 2*pi/3, sqrt(3)/2, -1/2),
            (135, 3*pi/4, sqrt(2)/2, -sqrt(2)/2),
            (150, 5*pi/6, 1/2, -sqrt(3)/2),
            (180, pi, 0, -1),
            (210, 7*pi/6, -1/2, -sqrt(3)/2),
            (225, 5*pi/4, -sqrt(2)/2, -sqrt(2)/2),
            (240, 4*pi/3, -sqrt(3)/2, -1/2),
            (270, 3*pi/2, -1, 0),
            (300, 5*pi/3, -sqrt(3)/2, 1/2),
            (315, 7*pi/4, -sqrt(2)/2, sqrt(2)/2),
            (330, 11*pi/6, -1/2, sqrt(3)/2)
        ]:
            t = s/c if c != 0 else None
            csc = 1/s if s != 0 else None
            sec = 1/c if c != 0 else None
            cot = c/s if s != 0 else None
            uc.append((deg, rad, s, c, t, csc, sec, cot))

        funcs = ["sin", "cos", "tan", "csc", "sec", "cot"]
        func_idx = {"sin": 2, "cos": 3, "tan": 4, "csc": 5, "sec": 6, "cot": 7}

        def dfrac(x):
            if x == 0:
                return "0"
            s = latex(x).replace(r"\frac{", r"\dfrac{")

            def repl_sqrt(m):
                num, den, rad = m.group(1), m.group(2), m.group(3)
                if num == "1":
                    return rf"\dfrac{{{rad}}}{{{den}}}"
                return rf"\dfrac{{{num}{rad}}}{{{den}}}"

            def repl_pi(m):
                num, den = m.group(1), m.group(2)
                if num == "1":
                    return rf"\dfrac{{\pi}}{{{den}}}"
                return rf"\dfrac{{{num}\pi}}{{{den}}}"

            # Rewrite forms like \dfrac{1}{2} \, \sqrt{3} to \dfrac{\sqrt{3}}{2}
            s = re.sub(r"\\dfrac\{([0-9]+)\}\{([0-9]+)\}\s*\\,\s*(\\sqrt\{[^}]+\})", repl_sqrt, s)
            # Rewrite forms like \dfrac{1}{2} \, \pi to \dfrac{\pi}{2}
            s = re.sub(r"\\dfrac\{([0-9]+)\}\{([0-9]+)\}\s*\\,\s*\\pi", repl_pi, s)
            return s

        content_lines = []
        outtro_lines = []

        for i in range(6):
            is_degree = (i < 3)
            func = choice(funcs)
            idx = func_idx[func]
            
            # Pick a target value that actually exists in the unit circle for this function
            target_val = choice(uc)[idx]

            if target_val is None:
                stmt = rf"\{func}\theta \text{{ is undefined}}"
            else:
                stmt = rf"\{func}\theta = {dfrac(target_val)}"
                
            sols = [u for u in uc if u[idx] == target_val]

            if is_degree:
                domain_str = r"[0^\circ, 360^\circ)"
                answers = [rf"{u[0]}^\circ" for u in sols]
            else:
                domain_str = r"[0, 2\pi)"
                answers = [dfrac(u[1]) for u in sols]

            letter = chr(97 + i)  # 'a', 'b', 'c', etc.
            ans_str = ", ".join(answers)

            content_lines.append(f"    <p><m>({letter}) \\quad {domain_str}: \\quad {stmt}, \\quad \\theta = \\underline{{\\hspace{{1.2in}}}}</m></p>")
            outtro_lines.append(f"    <p><m>({letter}) \\quad \\theta = {ans_str}</m></p>")

        return {
            "content_list": "\n".join(content_lines),
            "outtro": "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"
        }