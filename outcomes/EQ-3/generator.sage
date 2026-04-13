from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Select the trigonometric function
        func_str = random.choice(["sin", "cos"])
        u_tex = rf"\{func_str} \theta"
        u2_tex = rf"\{func_str}^2 \theta"
        
        # Build backwards to guarantee clean factorization
        # A and V represent the valid root (V/A)
        A = random.choice([1, 2])
        V = random.choice([1, -1])
        
        # I represents the invalid, extraneous root
        I = random.choice([2, -2, 3, -3])
        
        # Quadratic Expansion: (A u - V)(u - I) = A u^2 - (AI + V)u + VI = 0
        c2 = A
        c1 = -(A * I + V)
        c0 = V * I
        
        # Construct the Left Hand Side (LHS) of the initial equation: c2 u^2 + c1 u
        term2 = u2_tex if c2 == 1 else f"{c2}{u2_tex}"
        
        if c1 == 1:
            term1 = f"+ {u_tex}"
        elif c1 == -1:
            term1 = f"- {u_tex}"
        elif c1 > 0:
            term1 = f"+ {c1}{u_tex}"
        elif c1 < 0:
            term1 = f"- {-c1}{u_tex}"
        else:
            term1 = ""
            
        lhs_latex = f"{term2} {term1}".strip()
        
        # Construct the Right Hand Side (RHS) of the initial equation: -c0
        rhs_latex = f"{-c0}"
        
        # Step 1: Standard quadratic form (set to 0)
        term0 = f"+ {c0}" if c0 > 0 else f"- {-c0}"
        step1 = f"{term2} {term1} {term0} = 0".replace("  ", " ")
        
        # Step 2: Factored form
        if A == 1:
            fac1 = f"({u_tex} - {V})" if V > 0 else f"({u_tex} + {-V})"
        else:
            fac1 = f"({A}{u_tex} - {V})" if V > 0 else f"({A}{u_tex} + {-V})"
            
        fac2 = f"({u_tex} - {I})" if I > 0 else f"({u_tex} + {-I})"
        step2 = f"{fac1}{fac2} = 0"
        
        # Step 3: Set each factor to 0
        if A == 1:
            eq1_mid = f"{u_tex} - {V} = 0" if V > 0 else f"{u_tex} + {-V} = 0"
        else:
            eq1_mid = f"{A}{u_tex} - {V} = 0" if V > 0 else f"{A}{u_tex} + {-V} = 0"
            
        eq2_mid = f"{u_tex} - {I} = 0" if I > 0 else f"{u_tex} + {-I} = 0"
        step3 = f"{eq1_mid} \\quad \\text{{OR}} \\quad {eq2_mid}"
        
        # Step 4: Isolate the trigonometric function
        target_val = f"{V}" if A == 1 else latex(Integer(V) / Integer(A))
            
        eq1_iso = f"{u_tex} = {target_val}"
        eq2_iso = f"{u_tex} = {I}"
        step4 = f"{eq1_iso} \\quad \\text{{OR}} \\quad {eq2_iso}"
        
        # Step 5: Identify the extraneous solution
        step5 = f"{eq1_iso} \\quad \\text{{OR}} \\quad \\text{{No real solution}}"
        
        # Step 6: Final evaluation on [0, 2pi)
        roots_map = {
            "sin": {
                (1, 1): [pi/2],
                (-1, 1): [3*pi/2],
                (1, 2): [pi/6, 5*pi/6],
                (-1, 2): [7*pi/6, 11*pi/6]
            },
            "cos": {
                (1, 1): [0],
                (-1, 1): [pi],
                (1, 2): [pi/3, 5*pi/3],
                (-1, 2): [2*pi/3, 4*pi/3]
            }
        }
        
        thetas = roots_map[func_str][(V, A)]
        final_ans_list = [latex(ans) for ans in thetas]
        final_ans = ", ".join(final_ans_list)
        
        final_sol = rf"\boxed{{\theta = {final_ans}}}"
        
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