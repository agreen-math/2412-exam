from sage.all import *
import random


class Generator(BaseGenerator):
    def data(self):

        outer_trig = random.choice(["sin", "cos"])
        inverse_trig = random.choice(["sin", "cos", "tan", "csc", "sec", "cot"])

        allowed = list(range(-20, 21)) + [-30, -25, -24, 24, 25, 30]
        allowed = [n for n in allowed if n != 0]

        forbidden_rad = {1, 4, 9, 16, 25}

        while True:
            a = random.choice(allowed)
            b = random.choice(allowed)
            if a == b:
                continue
            rad = a*a + b*b
            if rad >= 30 or rad in forbidden_rad:
                continue
            break

        sin_tex = rf"\frac{{{a}}}{{\sqrt{{{rad}}}}}"
        cos_tex = rf"\frac{{{b}}}{{\sqrt{{{rad}}}}}"

        inv_op = rf"\{inverse_trig}^{{-1}}"

        def simp_frac(num, den):
            return latex(Integer(num) / Integer(den))

        if inverse_trig == "sin":
            inv_input = sin_tex
        elif inverse_trig == "cos":
            inv_input = cos_tex
        elif inverse_trig == "tan":
            inv_input = simp_frac(a, b)
        elif inverse_trig == "csc":
            inv_input = rf"\frac{{\sqrt{{{rad}}}}}{{{a}}}"
        elif inverse_trig == "sec":
            inv_input = rf"\frac{{\sqrt{{{rad}}}}}{{{b}}}"
        else:
            inv_input = simp_frac(b, a)

        if outer_trig == "sin":
            expression = rf"\sin\left(2{inv_op}\left({inv_input}\right)\right)"
            identity = r"\sin(2\alpha)=2\sin\alpha\cos\alpha"
            plug_math = rf"2\times\frac{{{a}}}{{\sqrt{{{rad}}}}}\times\frac{{{b}}}{{\sqrt{{{rad}}}}}"
            unsimplified = rf"\frac{{{2*a*b}}}{{{rad}}}"
            value = Integer(2*a*b) / Integer(rad)
        else:
            expression = rf"\cos\left(2{inv_op}\left({inv_input}\right)\right)"
            identity = r"\cos(2\alpha)=\cos^2\alpha-\sin^2\alpha"
            plug_math = (
                rf"\left(\frac{{{b}}}{{\sqrt{{{rad}}}}}\right)^2"
                rf"-\left(\frac{{{a}}}{{\sqrt{{{rad}}}}}\right)^2"
            )
            unsimplified = rf"\frac{{{b*b-a*a}}}{{{rad}}}"
            value = Integer(b*b - a*a) / Integer(rad)

        if value.is_integer():
            final_answer = str(value)
        else:
            final_answer = latex(value)

        solution = rf"""
<p>
    Let <m>\alpha</m> be the given inverse trigonometric angle.
</p>

<p>
    From the reference triangle,
    <m>\sin\alpha = {sin_tex}</m> and
    <m>\cos\alpha = {cos_tex}</m>.
</p>

<p>
    Using the identity <m>{identity}</m>:
</p>

<p>
    <m>{plug_math}</m>
</p>

<me>
    = {unsimplified}
</me>
"""

        outtro = rf"""
<outtro>
    <p><strong>Solution:</strong></p>
    {solution}
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