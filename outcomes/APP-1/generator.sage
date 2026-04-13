from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Pool of standard positive unit circle ratios
        # Format: (func_str, ratio_type, ratio_tex, base_thetas, valid_K_options)
        configs = [
            ('sin', "1/2", r"\frac{1}{2}", [pi/6, 5*pi/6], [6, 12, 18]),
            ('sin', "sqrt2/2", r"\frac{\sqrt{2}}{2}", [pi/4, 3*pi/4], [4, 8, 12]),
            ('sin', "sqrt3/2", r"\frac{\sqrt{3}}{2}", [pi/3, 2*pi/3], [3, 6, 9, 12]),
            ('cos', "1/2", r"\frac{1}{2}", [pi/3, 5*pi/3], [3, 6, 9, 12]),
            ('cos', "sqrt2/2", r"\frac{\sqrt{2}}{2}", [pi/4, 7*pi/4], [4, 8, 12]),
            ('cos', "sqrt3/2", r"\frac{\sqrt{3}}{2}", [pi/6, 11*pi/6], [6, 12, 18])
        ]
        
        func_str, ratio_type, ratio_tex, thetas, k_options = random.choice(configs)

        # Select Amplitude (A) as a strictly positive even integer
        A = random.choice([4, 6, 8, 10, 12, 14, 16, 18, 20])
        A_half = A // 2
        
        # Calculate the explicit LaTeX string for C to handle radicals cleanly
        if ratio_type == "1/2":
            C_tex = f"{A_half}"
        elif ratio_type == "sqrt2/2":
            C_tex = rf"{A_half}\sqrt{{2}}" if A_half != 1 else r"\sqrt{2}"
        elif ratio_type == "sqrt3/2":
            C_tex = rf"{A_half}\sqrt{{3}}" if A_half != 1 else r"\sqrt{3}"

        # Choose an appropriate K multiplier to guarantee integer roots
        K = random.choice(k_options)
        P = 2 * K
        B_tex = rf"\frac{{\pi}}{{{K}}}"

        # Calculate principal roots (guaranteed to be integers)
        t1 = int(thetas[0] * K / pi)
        t2 = int(thetas[1] * K / pi)

        # Ensure sequential listing
        if t1 > t2:
            t1, t2 = t2, t1

        # Generate first 4 terms for the final sequence
        ans_str = f"{t1}, {t2}, {t1 + P}, {t2 + P}, \\dots"

        # Flavor text contexts using <m> tags for the radical C value
        contexts = [
            {
                "desc": r"A weight attached to a spring is pulled and then released. After <m>t</m> seconds, its vertical displacement <m>d(t)</m> in inches is given by the equation below, where a positive value indicates the weight is above its resting equilibrium.",
                "task": rf"Find all values of <m>t</m> for which the weight is <m>{C_tex}</m> inches above its resting equilibrium."
            },
            {
                "desc": r"The ocean tide at a specific harbor is modeled by the equation below, where <m>d(t)</m> represents the water's height in feet above mean sea level after <m>t</m> hours.",
                "task": rf"Find all values of <m>t</m> for which the tide is <m>{C_tex}</m> feet above mean sea level."
            },
            {
                "desc": r"A buoy bobs up and down on the ocean waves. Its vertical displacement is modeled by the equation below, where <m>d(t)</m> represents the buoy's height in feet above the calm water level after <m>t</m> seconds.",
                "task": rf"Find all values of <m>t</m> for which the buoy is <m>{C_tex}</m> feet above the calm water level."
            }
        ]
        context = random.choice(contexts)

        # Prompt Equation
        func_tex = rf"\{func_str}"
        eq_lhs = rf"d(t) = {A} {func_tex}\left({B_tex} t\right)"

        # Step 1: Set equation
        step1 = rf"{C_tex} = {A} {func_tex}\left({B_tex} t\right)"

        # Step 2: Isolate trig function
        step2 = rf"{ratio_tex} = {func_tex}\left({B_tex} t\right)"

        # Step 3: Inverse trig notation
        step3 = rf"{func_tex}^{{-1}}\left({ratio_tex}\right) = {B_tex} t"

        # Step 4: Primary angles
        theta1_tex = latex(thetas[0])
        theta2_tex = latex(thetas[1])
        step4 = rf"{B_tex} t = {theta1_tex} \quad \text{{OR}} \quad {B_tex} t = {theta2_tex}"

        # Step 5: Solve for principal t
        step5 = rf"t = {t1} \quad \text{{OR}} \quad t = {t2}"

        # Step 6: Explicitly find Period
        step6 = rf"\text{{Period}} = 2\pi \cdot \frac{{{K}}}{{\pi}} = {P}"

        # Final Solution Sequence
        final_sol = rf"\boxed{{t = {ans_str}}}"

        outtro_lines = [
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p><m>{step4}</m></p>",
            f"    <p><m>{step5}</m></p>",
            f"    <p><m>{step6}</m></p>",
            f"    <p><m>{final_sol}</m></p>"
        ]
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"

        return {
            "desc": context["desc"],
            "eq": eq_lhs,
            "task": context["task"],
            "outtro": outtro
        }