from sage.all import *
import random
import math


class Generator(BaseGenerator):
    def data(self):

        # ----------------------------
        # Random choices
        # ----------------------------

        k = random.choice([1, 2, 3, 4, 5])

        allowed_c = (
            list(range(-20, 21)) +
            [-30, -25, -24, 24, 25, 30]
        )
        allowed_c = [x for x in allowed_c if x not in [-1, 0, 1]]
        c = random.choice(allowed_c)

        form = random.choice(["ku", "ku_over_c", "c_over_ku"])

        outer = random.choice(["sin", "cos", "tan"])
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        # ----------------------------
        # Build inverse‑trig argument
        # ----------------------------

        if form == "ku":
            coef = "" if k == 1 else str(k)
            arg = f"{coef}u"
            arg_sq = f"{k^2}u^2" if k != 1 else "u^2"

        elif form == "ku_over_c":
            coef = "" if k == 1 else str(k)
            arg = rf"\frac{{{coef}u}}{{{c}}}"
            arg_sq = rf"\frac{{{k^2}u^2}}{{{c^2}}}" if k != 1 else rf"\frac{{u^2}}{{{c^2}}}"

        else:  # c_over_ku
            coef = "" if k == 1 else str(k)
            arg = rf"\frac{{{c}}}{{{coef}u}}"
            arg_sq = rf"\frac{{{c^2}}}{{{k^2}u^2}}" if k != 1 else rf"\frac{{{c^2}}}{{u^2}}"

        # ----------------------------
        # Expression (render‑safe)
        # ----------------------------

        expression_me = rf"<m>\{outer}\!\left(2\{inv}^{{-1}}\!\left({arg}\right)\right)</m>"

        # ----------------------------
        # Trig values for alpha
        # ----------------------------

        # For sin^{-1}, csc^{-1}
        sin_a = rf"\frac{{{arg}}}{{\sqrt{{1+{arg_sq}}}}}"
        cos_a = rf"\frac{{1}}{{\sqrt{{1+{arg_sq}}}}}"

        # For cos^{-1}, sec^{-1}
        sin_b = rf"\frac{{1}}{{\sqrt{{1+{arg_sq}}}}}"
        cos_b = rf"\frac{{{arg}}}{{\sqrt{{1+{arg_sq}}}}}"

        # For tan^{-1}, cot^{-1}
        sin_c = rf"\frac{{{arg}}}{{\sqrt{{1+{arg_sq}}}}}"
        cos_c = rf"\frac{{1}}{{\sqrt{{1+{arg_sq}}}}}"

        # ----------------------------
        # Identity and final answer
        # ----------------------------

        if outer == "cos":
            identity = r"\cos(2\alpha)=1-2\sin^2\alpha"

            if inv in ["sin", "csc"]:
                final_answer = rf"1-2\left({sin_a}\right)^2"
            elif inv in ["cos", "sec"]:
                final_answer = rf"2\left({cos_b}\right)^2-1"
            else:
                final_answer = rf"\frac{{1-{arg_sq}}}{{1+{arg_sq}}}"

        elif outer == "sin":
            identity = r"\sin(2\alpha)=2\sin\alpha\cos\alpha"

            if inv in ["sin", "csc"]:
                final_answer = rf"2\left({sin_a}\right)\left({cos_a}\right)"
            elif inv in ["cos", "sec"]:
                final_answer = rf"2\left({sin_b}\right)\left({cos_b}\right)"
            else:
                final_answer = rf"\frac{{2{arg}}}{{1+{arg_sq}}}"

        else:  # tan
            identity = r"\tan(2\alpha)=\frac{2\tan\alpha}{1-\tan^2\alpha}"
            final_answer = rf"\frac{{2{arg}}}{{1-{arg_sq}}}"

        # ----------------------------
        # Outro
        # ----------------------------

        outtro = rf"""
<outtro>
    <p><strong>Solution:</strong></p>

    <p>
        Let <m>\alpha=\{inv}^{{-1}}\!\left({arg}\right)</m>.
    </p>

    <p>
        Using the identity <m>{identity}</m>:
    </p>

    <p>
        <m>{final_answer}</m>
    </p>

    <p>
        <strong>Final Answer:</strong>
        <m>{final_answer}</m>
    </p>
</outtro>
"""

        return {
            "expression_me": expression_me,
            "outtro": outtro
        }