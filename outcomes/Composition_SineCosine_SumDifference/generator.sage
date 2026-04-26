from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):

        def random_legs():
            while True:
                opp = random.choice([i for i in range(-20, 21) if i != 0])
                adj = random.choice([i for i in range(-20, 21) if i != 0])
                hyp2 = opp^2 + adj^2
                if max(abs(opp), abs(adj), sqrt(hyp2)) <= 30:
                    return opp, adj, hyp2

        def inv_expr(inv, opp, adj, hyp2):
            if inv == "sin":
                return rf"\sin^{{-1}}\left(\frac{{{opp}}}{{\sqrt{{{hyp2}}}}}\right)"
            if inv == "cos":
                return rf"\cos^{{-1}}\left(\frac{{{adj}}}{{\sqrt{{{hyp2}}}}}\right)"
            if inv == "tan":
                return rf"\tan^{{-1}}\left(\frac{{{opp}}}{{{adj}}}\right)"
            if inv == "csc":
                return rf"\csc^{{-1}}\left(\frac{{\sqrt{{{hyp2}}}}}{{{opp}}}\right)"
            if inv == "sec":
                return rf"\sec^{{-1}}\left(\frac{{\sqrt{{{hyp2}}}}}{{{adj}}}\right)"
            return rf"\cot^{{-1}}\left(\frac{{{adj}}}{{{opp}}}\right)"

        opp1, adj1, hyp2_1 = random_legs()
        opp2, adj2, hyp2_2 = random_legs()

        inv_funcs = ["sin", "cos", "tan", "csc", "sec", "cot"]
        inv1 = random.choice(inv_funcs)
        inv2 = random.choice(inv_funcs)

        op = random.choice(["+", "-"])
        outer = random.choice(["sin", "cos"])

        expression = rf"\{outer}\left({inv_expr(inv1, opp1, adj1, hyp2_1)} {op} {inv_expr(inv2, opp2, adj2, hyp2_2)}\right)"

        # We must use double braces {{ }} here because these will be nested inside another f-string later.
        sin_a = rf"\frac{{{opp1}}}{{\sqrt{{{hyp2_1}}}}}"
        cos_a = rf"\frac{{{adj1}}}{{\sqrt{{{hyp2_1}}}}}"
        sin_b = rf"\frac{{{opp2}}}{{\sqrt{{{hyp2_2}}}}}"
        cos_b = rf"\frac{{{adj2}}}{{\sqrt{{{hyp2_2}}}}}"

        if outer == "sin":
            identity = r"\sin(\alpha\pm\beta)=\sin\alpha\cos\beta\pm\cos\alpha\sin\beta"
            expanded = rf"{sin_a}\cdot{cos_b} {'+' if op=='+' else '-'} {cos_a}\cdot{sin_b}"
            numeric = (
                (opp1/sqrt(hyp2_1))*(adj2/sqrt(hyp2_2))
                + (adj1/sqrt(hyp2_1))*(opp2/sqrt(hyp2_2))
                if op == "+"
                else
                (opp1/sqrt(hyp2_1))*(adj2/sqrt(hyp2_2))
                - (adj1/sqrt(hyp2_1))*(opp2/sqrt(hyp2_2))
            )
        else:
            identity = r"\cos(\alpha\pm\beta)=\cos\alpha\cos\beta\mp\sin\alpha\sin\beta"
            expanded = rf"{cos_a}\cdot{cos_b} {'-' if op=='+' else '+'} {sin_a}\cdot{sin_b}"
            numeric = (
                (adj1/sqrt(hyp2_1))*(adj2/sqrt(hyp2_2))
                - (opp1/sqrt(hyp2_1))*(opp2/sqrt(hyp2_2))
                if op == "+"
                else
                (adj1/sqrt(hyp2_1))*(adj2/sqrt(hyp2_2))
                + (opp1/sqrt(hyp2_1))*(opp2/sqrt(hyp2_2))
            )

        final_ans = latex(simplify(numeric))

        outtro = rf"""
<outtro>
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

    <me>
        = {expanded}
    </me>

    <p>
        Simplifying, we find the final result:
    </p>

    <me>
        = {final_ans}
    </me>
</outtro>
        """

        return {
            "expression": expression,
            "outtro": outtro
        }