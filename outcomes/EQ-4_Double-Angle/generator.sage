from sage.all import *
import random
import math

class Generator(BaseGenerator):
    def data(self):
        for _ in range(200):

            primary = random.choice(["sin", "cos"])
            secondary = random.choice(["sin", "cos", "tan", "sec", "csc", "cot"])

            # ----- Build ratio r -----
            form = random.choice(["rat", "sqrt_num", "sqrt_den"])

            if form == "rat":
                a = random.choice([i for i in range(-9, 10) if i not in [-1, 0, 1]])
                b = random.randint(2, 10)
                r = QQ(a) / b
                r_tex = "\\frac{%d}{%d}" % (a, b)

            elif form == "sqrt_num":
                n = random.choice([k for k in range(2, 41) if not is_square(k)])
                k = random.randint(2, 6)
                r = sqrt(n) / k
                r_tex = "\\frac{\\sqrt{%d}}{%d}" % (n, k)

            else:
                n = random.choice([k for k in range(2, 41) if not is_square(k)])
                k = random.randint(2, 6)
                r = k / sqrt(n)
                r_tex = "\\frac{%d}{\\sqrt{%d}}" % (k, n)

            # ----- Domain enforcement -----
            if secondary in ["sin", "cos", "tan", "cot"]:
                if not (abs(r) < 1 and r != 0):
                    continue
            else:
                if abs(r) <= 1:
                    continue

            # ----- Compute numeric value of answer -----
            r2 = r*r

            if secondary in ["sin", "cos"]:
                sin2 = 2*r*sqrt(1 - r2)
                cos2 = 1 - 2*r2

            elif secondary in ["tan", "cot"]:
                sin2 = 2*r/(1 + r2)
                cos2 = (1 - r2)/(1 + r2)

            elif secondary == "sec":
                sin2 = 2*sqrt(r2 - 1)/(r2)
                cos2 = (2 - r2)/r2

            else:  # csc
                sin2 = 2*sqrt(r2 - 1)/(r2)
                cos2 = (r2 - 2)/r2

            # ----- Choose x and enforce inverse domain -----
            if primary == "sin":
                x_val = sin2
                if not (abs(x_val) < 1 and x_val != 0):
                    continue
                primary_tex = "\\sin^{-1}"
            else:
                x_val = cos2
                if not (0 < x_val < 1):
                    continue
                primary_tex = "\\cos^{-1}"

            # ----- MANUAL answer formatting (critical) -----
            x_val = x_val.simplify()

            if x_val in QQ:
                answer = latex(x_val)
            else:
                # extract sqrt(N)/K form numerically
                num = x_val.numerator()
                den = x_val.denominator()

                if num.operator() is sqrt:
                    answer = "\\frac{\\sqrt{%s}}{%s}" % (
                        num.operands()[0], den
                    )
                elif den.operator() is sqrt:
                    answer = "\\frac{%s}{\\sqrt{%s}}" % (
                        num, den.operands()[0]
                    )
                else:
                    continue  # reject unsafe form

            secondary_tex = "\\" + secondary + "^{-1}"

            eq_type = random.choice([1, 2, 3])
            if eq_type == 1:
                equation = "%s(x)=2%s(%s)" % (
                    primary_tex, secondary_tex, r_tex
                )
            elif eq_type == 2:
                equation = "%s(x)-%s(%s)=%s(%s)" % (
                    primary_tex, secondary_tex, r_tex,
                    secondary_tex, r_tex
                )
            else:
                equation = "%s(%s)=%s(x)-%s(%s)" % (
                    secondary_tex, r_tex,
                    primary_tex,
                    secondary_tex, r_tex
                )

            return {
                "equation": equation,
                "answer": answer
            }

        raise RuntimeError("Failed to generate problem.")