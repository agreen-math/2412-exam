from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Choose inverse trig type
        inv_type = random.choice(["sin", "cos"])

        # Choose non-Pythagorean triangle legs
        # (a, b, hyp) with hyp = sqrt(a^2 + b^2), not a triple
        a = random.choice([2, 3, 4, 5])
        b = random.choice([3, 5, 6, 7])

        # Reject accidental triples
        while a*a + b*b in [25, 169, 289]:
            b = random.choice([3, 5, 6, 7])

        hyp = sqrt(a*a + b*b)

        if inv_type == "sin":
            expression = rf"\sin\left(2\sin^{{-1}}\left(\frac{{{a}}}{{\sqrt{{{a*a+b*b}}}}}\right)\right)"
            sin_alpha = rf"\frac{{{a}}}{{\sqrt{{{a*a+b*b}}}}}"
            cos_alpha = rf"\frac{{{b}}}{{\sqrt{{{a*a+b*b}}}}}"
            answer = rf"\frac{{{2*a*b}}}{{{a*a+b*b}}}"

            identity = r"\sin(2\alpha)=2\sin\alpha\cos\alpha"

        else:
            expression = rf"\cos\left(2\cos^{{-1}}\left(\frac{{{b}}}{{\sqrt{{{a*a+b*b}}}}}\right)\right)"
            sin_alpha = rf"\frac{{{a}}}{{\sqrt{{{a*a+b*b}}}}}"
            cos_alpha = rf"\frac{{{b}}}{{\sqrt{{{a*a+b*b}}}}}"
            answer = rf"\frac{{{b*b - a*a}}}{{{a*a+b*b}}}"

            identity = r"\cos(2\alpha)=\cos^2\alpha-\sin^2\alpha"

        solution = rf"""
        <p>
            Let <m>\alpha</m> be the given inverse trigonometric angle.
        </p>

        <p>
            From the reference triangle,
            <m>\sin\alpha = {sin_alpha}</m> and
            <m>\cos\alpha = {cos_alpha}</m>.
        </p>

        <p>
            Using the identity <m>{identity}</m>:
        </p>

        <me>
            = {answer}
        </me>
        """

        outtro = rf"""
        <outtro>
            <p><strong>Solution:</strong></p>
            {solution}
            <p>
                <strong>Final Answer:</strong>
                <m>{answer}</m>
            </p>
        </outtro>
        """

        return {
            "expression": expression,
            "outtro": outtro
        }