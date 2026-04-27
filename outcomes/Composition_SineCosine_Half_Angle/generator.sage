from sage.all import *
import random
import math


class Generator(BaseGenerator):
    def data(self):

        # ----------------------------
        # Allowed values (NC policy)
        # ----------------------------

        allowed = list(range(-20, 21)) + [-30, -25, -24, 24, 25, 30]
        allowed = [n for n in allowed if n != 0]
        forbidden_rad = {1, 4, 9, 16, 25}

        def random_triangle():
            while True:
                opp = random.choice(allowed)
                adj = random.choice(allowed)
                rad = opp*opp + adj*adj
                if rad >= 30:
                    continue
                if rad in forbidden_rad:
                    continue
                return opp, adj, rad

        # ----------------------------
        # Random data
        # ----------------------------

        opp, adj, rad = random_triangle()

        outer = random.choice(["sin", "cos", "tan"])
        inv = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        sin_alpha = rf"\frac{{{opp}}}{{\sqrt{{{rad}}}}}"
        cos_alpha = rf"\frac{{{adj}}}{{\sqrt{{{rad}}}}}"

        # Inverse trig input
        if inv == "sin":
            inv_input = sin_alpha
            alpha_negative = opp < 0
        elif inv == "csc":
            inv_input = rf"\frac{{\sqrt{{{rad}}}}}{{{opp}}}"
            alpha_negative = opp < 0
        elif inv == "tan":
            inv_input = rf"\frac{{{opp}}}{{{adj}}}"
            alpha_negative = opp*adj < 0
        elif inv == "cot":
            inv_input = rf"\frac{{{adj}}}{{{opp}}}"
            alpha_negative = False   # cot^{-1} ∈ (0, π)
        elif inv == "sec":
            inv_input = rf"\frac{{\sqrt{{{rad}}}}}{{{adj}}}"
            alpha_negative = False
        else:  # cos
            inv_input = cos_alpha
            alpha_negative = False

        # ----------------------------
        # Expression (working format)
        # ----------------------------

        expr_latex = rf"\{outer}\!\left(\tfrac12\,\{inv}^{{-1}}\!\left({inv_input}\right)\right)"
        expression_me = rf"<m>{expr_latex}</m>"

        # ----------------------------
        # Half-angle logic with sign
        # ----------------------------

        if outer == "sin":
            identity = r"\sin(\tfrac{\alpha}{2})=\pm\sqrt{\frac{1-\cos\alpha}{2}}"

            num = rad - adj
            D = 2 * rad

            g = math.gcd(abs(num), D)
            num_red = num // g
            den_red = D // g

            sign = "-" if alpha_negative else ""
            final_answer = rf"{sign}\frac{{\sqrt{{{num_red * den_red}}}}}{{{den_red}}}"
            plug = rf"\sqrt{{\frac{{1 - {cos_alpha}}}{{2}}}}"

        elif outer == "cos":
            identity = r"\cos(\tfrac{\alpha}{2})=\sqrt{\frac{1+\cos\alpha}{2}}"

            num = rad + adj
            D = 2 * rad

            g = math.gcd(abs(num), D)
            num_red = num // g
            den_red = D // g

            final_answer = rf"\frac{{\sqrt{{{num_red * den_red}}}}}{{{den_red}}}"
            plug = rf"\sqrt{{\frac{{1 + {cos_alpha}}}{{2}}}}"

        else:  # tan
            identity = r"\tan(\tfrac{\alpha}{2})=\frac{1-\cos\alpha}{\sin\alpha}"

            num = rad - adj
            den = opp

            g = math.gcd(abs(num), abs(den))
            num_red = num // g
            den_red = den // g

            if den_red < 0:
                num_red *= -1
                den_red *= -1

            final_answer = rf"\frac{{{num_red}}}{{{den_red}}}"
            plug = rf"\frac{{1 - {cos_alpha}}}{{{sin_alpha}}}"

        # ----------------------------
        # Outro
        # ----------------------------

        outtro = rf"""
<outtro>
    <p><strong>Solution:</strong></p>

    <p>
        Let <m>\alpha</m> be the angle defined by the inverse trigonometric expression.
    </p>

    <p>
        From the reference triangle,
        <m>\sin\alpha={sin_alpha}</m> and
        <m>\cos\alpha={cos_alpha}</m>.
    </p>

    <p>
        Using the identity <m>{identity}</m>:
    </p>

    <p>
        <m>{plug}</m>
    </p>

    <p>
        The sign is determined by the principal range of <m>\{inv}^{{-1}}</m>.
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