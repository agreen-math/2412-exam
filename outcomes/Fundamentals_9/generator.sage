from sage.all import *
import re

class Generator(BaseGenerator):
    def data(self):

        uc = [
            (0, 0, 0, 1, 0),
            (30, pi/6, 1/2, sqrt(3)/2, sqrt(3)/3),
            (45, pi/4, sqrt(2)/2, sqrt(2)/2, 1),
            (60, pi/3, sqrt(3)/2, 1/2, sqrt(3)),
            (90, pi/2, 1, 0, None),
            (120, 2*pi/3, sqrt(3)/2, -1/2, -sqrt(3)),
            (135, 3*pi/4, sqrt(2)/2, -sqrt(2)/2, -1),
            (150, 5*pi/6, 1/2, -sqrt(3)/2, -sqrt(3)/3),
            (180, pi, 0, -1, 0),
            (210, 7*pi/6, -1/2, -sqrt(3)/2, sqrt(3)/3),
            (225, 5*pi/4, -sqrt(2)/2, -sqrt(2)/2, 1),
            (240, 4*pi/3, -sqrt(3)/2, -1/2, sqrt(3)),
            (270, 3*pi/2, -1, 0, None),
            (300, 5*pi/3, -sqrt(3)/2, 1/2, -sqrt(3)),
            (315, 7*pi/4, -sqrt(2)/2, sqrt(2)/2, -1),
            (330, 11*pi/6, -1/2, sqrt(3)/2, -sqrt(3)/3),
        ]

        funcs = ["sin", "cos", "tan", "csc", "sec", "cot"]

        def dfrac(x):
            s = latex(x).replace(r"\frac{", r"\dfrac{")

            def repl_sqrt(m):
                num = m.group(1)
                den = m.group(2)
                rad = m.group(3)
                if num == "1":
                    return r"\dfrac{" + rad + r"}{" + den + r"}"
                return r"\dfrac{" + num + rad + r"}{" + den + r"}"

            def repl_pi(m):
                num = m.group(1)
                den = m.group(2)
                if num == "1":
                    return r"\dfrac{\pi}{" + den + r"}"
                return r"\dfrac{" + num + r"\pi}{" + den + r"}"

            # Rewrite forms like \dfrac{1}{2} \, \sqrt{3} to \dfrac{\sqrt{3}}{2}
            # and \dfrac{2}{3} \, \sqrt{3} to \dfrac{2\sqrt{3}}{3}.
            s = re.sub(
                r"\\dfrac\{([0-9]+)\}\{([0-9]+)\}\s*\\,\s*(\\sqrt\{[^}]+\})",
                repl_sqrt,
                s,
            )
            # Rewrite forms like \dfrac{1}{2} \, \pi to \dfrac{\pi}{2}
            # and \dfrac{3}{2} \, \pi to \dfrac{3\pi}{2}.
            s = re.sub(
                r"\\dfrac\{([0-9]+)\}\{([0-9]+)\}\s*\\,\s*\\pi",
                repl_pi,
                s,
            )
            return s

        def make_part(is_degree):
            func = choice(funcs)
            deg, rad, s, c, t = choice(uc)

            if func == "sin":
                val, key = s, 2
            elif func == "cos":
                val, key = c, 3
            elif func == "tan":
                val, key = t, 4
            elif func == "csc":
                val, key = (None if s == 0 else 1/s), 2
            elif func == "sec":
                val, key = (None if c == 0 else 1/c), 3
            else:  # cot
                val, key = (None if t in (0, None) else 1/t), 4

            if val is None:
                stmt = r"\%s\theta\text{ is undefined}" % func
                sols = [u for u in uc if u[key] in (0, None)]
            else:
                stmt = r"\%s\theta=%s" % (func, dfrac(val))
                sols = [u for u in uc if u[key] == (s if key==2 else c if key==3 else t)]

            if is_degree:
                answers = [r"%d^\circ" % u[0] for u in sols if 0 <= u[0] < 360]
            else:
                answers = [dfrac(u[1]) for u in sols if 0 <= u[1] < 2*pi]

            return stmt, ", ".join(answers)

        q, a = [], []

        for i in range(6):
            qi, ai = make_part(i < 3)
            q.append(qi)
            a.append(ai)

        return {
            "q1": q[0], "q2": q[1], "q3": q[2],
            "q4": q[3], "q5": q[4], "q6": q[5],
            "a1": a[0], "a2": a[1], "a3": a[2],
            "a4": a[3], "a5": a[4], "a6": a[5],
        }
