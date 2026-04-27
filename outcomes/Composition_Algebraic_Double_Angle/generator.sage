from sage.all import *
import random


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

        # Outer trig restricted to sine or cosine
        outer = random.choice(["sin", "cos"])

        # Inverse trig: ALL SIX
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        # ----------------------------
        # Build inverse-trig argument
        # ----------------------------

        if form == "ku":
            coef = "" if k == 1 else str(k)
            arg = f"{coef}u"

        elif form == "ku_over_c":
            coef = "" if k == 1 else str(k)
            arg = rf"\frac{{{coef}u}}{{{c}}}"

        else:  # c_over_ku
            coef = "" if k == 1 else str(k)
            arg = rf"\frac{{{c}}}{{{coef}u}}"

        # ----------------------------
        # Expression (render-safe)
        # ----------------------------

        expression_me = rf"<m>\{outer}\!\left(2\{inv}^{{-1}}\!\left({arg}\right)\right)</m>"

        # ----------------------------
        # Build reference triangle CORRECTLY
        # ----------------------------

        if inv == "sin":
            # sin(alpha) = arg
            sin_alpha = arg
            cos_alpha = rf"\sqrt{{1-({arg})^2}}"

        elif inv == "cos":
            # cos(alpha) = arg
            cos_alpha = arg
            sin_alpha = rf"\sqrt{{1-({arg})^2}}"

        elif inv == "tan":
            # tan(alpha) = arg = opp/adj
            sin_alpha = rf"\frac{{{arg}}}{{\sqrt{{1+({arg})^2}}}}"
            cos_alpha = rf"\frac{{1}}{{\sqrt{{1+({arg})^2}}}}"

        elif inv == "csc":
            # csc(alpha) = arg = hyp/opp
            # hyp = arg, opp = 1
            sin_alpha = rf"\frac{{1}}{{{arg}}}"
            cos_alpha = rf"\frac{{\sqrt{{({arg})^2-1}}}}{{{arg}}}"

        elif inv == "sec":
            # sec(alpha) = arg = hyp/adj
            cos_alpha = rf"\frac{{1}}{{{arg}}}"
            sin_alpha = rf"\frac{{\sqrt{{({arg})^2-1}}}}{{{arg}}}"

        else:  # cot
            # cot(alpha) = arg = adj/opp
            sin_alpha = rf"\frac{{1}}{{\sqrt{{1+({arg})^2}}}}"
            cos_alpha = rf"\frac{{{arg}}}{{\sqrt{{1+({arg})^2}}}}"

        # ----------------------------
        # Double-angle identity, plug-in, final answer
        # ----------------------------

        if outer == "sin":
            identity = r"\sin(2\alpha)=2\sin\alpha\cos\alpha"

            # Plug-in line: MUST stay a product
            plug = rf"2\times{sin_alpha}\times{cos_alpha}"

            # Final answer: multiply triangle ratios explicitly
            # sin(2α) = 2*(opp/hyp)*(adj/hyp) = 2*opp*adj / hyp^2

            if inv == "csc":
                # hyp = arg, opp = 1, adj = sqrt(arg^2-1)
                num_tex = rf"2\sqrt{{({arg})^2-1}}"
                den_tex = rf"({arg})^2"
                final_answer = rf"\frac{{{num_tex}}}{{{den_tex}}}"
            else:
                # Generic exact product
                final_answer = rf"2({sin_alpha})({cos_alpha})"

        else:  # cos
            identity = r"\cos(2\alpha)=1-2\sin^2\alpha"
            plug = rf"1-2\left({sin_alpha}\right)^2"
            final_answer = plug

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
        <m>{plug}</m>
    </p>

    <p>
        Since <m>u&gt;0</m>, the expression is well-defined.
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