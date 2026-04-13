from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        x, k = var('x k')

        # Target configurations: (func_str, D_expr, D_latex, target_val_latex, theta_list)
        # theta_list contains the base angles for x/2 that fall within (0, pi]
        configs = [
            ("sin", 1, "1", r"\frac{1}{2}", [pi/6, 5*pi/6]),
            ("sin", sqrt(2), r"\sqrt{2}", r"\frac{\sqrt{2}}{2}", [pi/4, 3*pi/4]),
            ("sin", sqrt(3), r"\sqrt{3}", r"\frac{\sqrt{3}}{2}", [pi/3, 2*pi/3]),
            ("sin", 2, "2", "1", [pi/2]),
            ("cos", sqrt(3), r"\sqrt{3}", r"\frac{\sqrt{3}}{2}", [pi/6]),
            ("cos", sqrt(2), r"\sqrt{2}", r"\frac{\sqrt{2}}{2}", [pi/4]),
            ("cos", 1, "1", r"\frac{1}{2}", [pi/3]),
            ("cos", 0, "0", "0", [pi/2]),
            ("cos", -1, "-1", r"-\frac{1}{2}", [2*pi/3]),
            ("cos", -sqrt(2), r"-\sqrt{2}", r"-\frac{\sqrt{2}}{2}", [3*pi/4]),
            ("cos", -sqrt(3), r"-\sqrt{3}", r"-\frac{\sqrt{3}}{2}", [5*pi/6]),
            ("cos", -2, "-2", "-1", [pi])
        ]

        func_str, D_expr, D_latex, target_latex, thetas = random.choice(configs)

        # Ensure A and C are non-zero integers where A - C = 2
        C = random.choice([-3, -1, 1, 2, 3])
        A = C + 2

        # Construct the Left Hand Side (LHS)
        if A == 1:
            lhs_latex = rf"\{func_str}\left(\frac{{x}}{{2}}\right)"
        elif A == -1:
            lhs_latex = rf"-\{func_str}\left(\frac{{x}}{{2}}\right)"
        else:
            lhs_latex = rf"{A}\{func_str}\left(\frac{{x}}{{2}}\right)"

        # Construct the Right Hand Side (RHS)
        if D_expr == 0:
            if C == 1:
                rhs_latex = rf"\{func_str}\left(\frac{{x}}{{2}}\right)"
            elif C == -1:
                rhs_latex = rf"-\{func_str}\left(\frac{{x}}{{2}}\right)"
            else:
                rhs_latex = rf"{C}\{func_str}\left(\frac{{x}}{{2}}\right)"
        else:
            if C == 1:
                rhs_latex = rf"{D_latex} + \{func_str}\left(\frac{{x}}{{2}}\right)"
            elif C == -1:
                rhs_latex = rf"{D_latex} - \{func_str}\left(\frac{{x}}{{2}}\right)"
            elif C < 0:
                rhs_latex = rf"{D_latex} - {abs(C)}\{func_str}\left(\frac{{x}}{{2}}\right)"
            else:
                rhs_latex = rf"{D_latex} + {C}\{func_str}\left(\frac{{x}}{{2}}\right)"

        # Step 1: Combine like terms
        step1 = rf"2\{func_str}\left(\frac{{x}}{{2}}\right) = {D_latex}"

        # Step 2: Isolate the trigonometric function
        step2 = rf"\{func_str}\left(\frac{{x}}{{2}}\right) = {target_latex}"

        # Step 3: Establish the inverse trigonometric relationship
        step3 = rf"\frac{{x}}{{2}} = \{func_str}^{{-1}}\left({target_latex}\right)"

        # Step 4 & 5: Express the general sequence and solve for x
        step4_list = []
        step5_list = []
        final_ans_list = []

        for theta in thetas:
            step4_list.append(rf"{latex(theta)} + 2\pi k")
            step5_list.append(rf"{latex(2*theta)} + 4\pi k")
            final_ans_list.append(rf"{latex(2*theta)}")

        step4 = rf"\frac{{x}}{{2}} = " + ", ".join(step4_list)
        step5 = rf"x = " + ", ".join(step5_list)

        final_ans = ", ".join(final_ans_list)
        final_sol = rf"\boxed{{x = {final_ans}}}"

        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{step2}</m></p>\n"
            f"    <p><m>{step3}</m></p>\n"
            f"    <p><m>{step4}</m></p>\n"
            f"    <p><m>{step5}</m></p>\n"
            f"    <p><m>{final_sol}</m></p>\n"
            f"</outtro>"
        )

        return {
            "lhs": lhs_latex,
            "rhs": rhs_latex,
            "outtro": outtro
        }