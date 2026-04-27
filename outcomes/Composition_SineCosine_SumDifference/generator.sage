from sage.all import *
import random
import math


class Generator(BaseGenerator):
    def data(self):

        # ----------------------------
        # Helpers and constraints
        # ----------------------------

        allowed = list(range(-20, 21)) + [-30, -25, -24, 24, 25, 30]
        allowed = [n for n in allowed if n != 0]
        forbidden_rad = {1, 4, 9, 16, 25}

        def simp_frac(num, den):
            return latex(Integer(num) / Integer(den))

        def random_triangle():
            while True:
                opp = random.choice(allowed)
                adj = random.choice(allowed)
                if opp == adj:
                    continue
                rad = opp*opp + adj*adj
                if rad >= 30:
                    continue
                if rad in forbidden_rad:
                    continue
                return opp, adj, rad

        def inv_expr(inv, opp, adj, rad):
            if inv == "sin":
                return rf"\sin^{{-1}}\!\left(\frac{{{opp}}}{{\sqrt{{{rad}}}}}\right)"
            if inv == "cos":
                return rf"\cos^{{-1}}\!\left(\frac{{{adj}}}{{\sqrt{{{rad}}}}}\right)"
            if inv == "tan":
                return rf"\tan^{{-1}}\!\left({simp_frac(opp, adj)}\right)"
            if inv == "csc":
                return rf"\csc^{{-1}}\!\left(\frac{{\sqrt{{{rad}}}}}{{{opp}}}\right)"
            if inv == "sec":
                return rf"\sec^{{-1}}\!\left(\frac{{\sqrt{{{rad}}}}}{{{adj}}}\right)"
            return rf"\cot^{{-1}}\!\left({simp_frac(adj, opp)}\right)"

        # ----------------------------
        # Random data
        # ----------------------------

        opp1, adj1, rad1 = random_triangle()
        opp2, adj2, rad2 = random_triangle()

        inv_funcs = ["sin", "cos", "tan", "csc", "sec", "cot"]
        inv1 = random.choice(inv_funcs)
        inv2 = random.choice(inv_funcs)

        op = random.choice(["+", "-"])
        outer = random.choice(["sin", "cos"])

        expression = rf"\{outer}\!\left({inv_expr(inv1, opp1, adj1, rad1)} {op} {inv_expr(inv2, opp2, adj2, rad2)}\right)"

        sin_a = rf"\frac{{{opp1}}}{{\sqrt{{{rad1}}}}}"
        cos_a = rf"\frac{{{adj1}}}{{\sqrt{{{rad1}}}}}"
        sin_b = rf"\frac{{{opp2}}}{{\sqrt{{{rad2}}}}}"
        cos_b = rf"\frac{{{adj2}}}{{\sqrt{{{rad2}}}}}"

        # ----------------------------
        # Identity and raw numerator
        # ----------------------------

        if outer == "sin":
            identity = r"\sin(\alpha\pm\beta)=\sin\alpha\cos\beta\pm\cos\alpha\sin\beta"
            plug = (
                rf"\sin\alpha\cos\beta {'+' if op=='+' else '-'} \cos\alpha\sin\beta"
                rf"=({sin_a})({cos_b}) {'+' if op=='+' else '-'} ({cos_a})({sin_b})"
            )
            num = opp1*adj2 + (adj1*opp2 if op == "+" else -adj1*opp2)
        else:
            identity = r"\cos(\alpha\pm\beta)=\cos\alpha\cos\beta\mp\sin\alpha\sin\beta"
            plug = (
                rf"\cos\alpha\cos\beta {'-' if op=='+' else '+'} \sin\alpha\sin\beta"
                rf"=({cos_a})({cos_b}) {'-' if op=='+' else '+'} ({sin_a})({sin_b})"
            )
            num = adj1*adj2 - (opp1*opp2 if op == "+" else -opp1*opp2)

        # ----------------------------
        # ✅ FINAL ANSWER — MANUAL CANONICAL FORM
        # ----------------------------

        D = rad1 * rad2

        # Reduce common factors
        g = math.gcd(abs(num), D)
        num_red = num // g
        den_red = D // g

        if num_red == 0:
            final_answer = "0"
        else:
            final_answer = rf"\frac{{{num_red}\sqrt{{{den_red}}}}}{{{den_red}}}"

        # ----------------------------
        # Outro (validated structure)
        # ----------------------------

        outtro = rf"""
<outtro>
    <p><strong>Solution:</strong></p>

    <p>
        Let <m>\alpha</m> and <m>\beta</m> be the angles defined by the inverse trigonometric expressions.
    </p>

    <p>
        From the reference triangles:
        <m>\sin\alpha={sin_a}</m>,
        <m>\cos\alpha={cos_a}</m>,
        <m>\sin\beta={sin_b}</m>,
        <m>\cos\beta={cos_b}</m>.
    </p>

    <p>
        Using the identity <m>{identity}</m>:
    </p>

    <p>
        <m>{plug}</m>
    </p>

    <p>
        <strong>Final Answer:</strong>
        <m>{final_answer}</m>
    </p>
</outtro>
"""

        return {
            "expression": expression,
            "outtro": outtro
        }