from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        problem_type = random.choice(["all_triple", "mixed", "non_triple"])

        if problem_type == "all_triple":
            # 3-4-5 triangle
            expr = r"\cos\left(\sin^{-1}\left(\frac{3}{5}\right)+\tan^{-1}\left(\frac{4}{3}\right)\right)"
            answer = r"0"
            category = "All values come from a Pythagorean triple."
        elif problem_type == "mixed":
            # One triple (5-12-13), one non-triple
            expr = r"\sin\left(\tan^{-1}\left(\frac{5}{12}\right)+\sin^{-1}\left(\frac{2}{\sqrt{13}}\right)\right)"
            answer = r"\frac{3\sqrt{13}}{13}"
            category = "One inverse trig ratio comes from a Pythagorean triple."
        else:
            # No triples
            options = [
                (
                    r"\cos\left(\tan^{-1}\left(\frac{2}{\sqrt{5}}\right)-\cos^{-1}\left(\frac{1}{\sqrt{6}}\right)\right)",
                    r"\frac{\sqrt{30}}{6}"
                ),
                (
                    r"\sin\left(\sin^{-1}\left(\frac{3}{\sqrt{10}}\right)+\tan^{-1}\left(\frac{1}{\sqrt{3}}\right)\right)",
                    r"\frac{3\sqrt{30}+\sqrt{10}}{20}"
                ),
                (
                    r"\cos\left(\sec^{-1}\left(\frac{4}{\sqrt{7}}\right)+\sin^{-1}\left(\frac{1}{\sqrt{5}}\right)\right)",
                    r"\frac{2\sqrt{35}-3\sqrt{5}}{20}"
                )
            ]
            expr, answer = random.choice(options)
            category = "No Pythagorean triples are used."

        # Assemble the outtro (incorporating the category note safely)
        outtro = (
            f"<outtro>\n"
            f"    <p><m>\\text{{Answer: }} {answer}</m></p>\n"
            f"    <p><em>Category: {category}</em></p>\n"
            f"</outtro>"
        )

        return {
            "expression": expr,
            "outtro": outtro
        }