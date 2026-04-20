import random

class Generator(BaseGenerator):
    def data(self):
        # Determine the point x approaches and format it for clarity
        c_val = choice(range(-9, 10))
        c_str = f"({c_val})" if c_val < 0 else str(c_val)
        
        # Limit of f(x) forced to be a perfect square
        m = choice(range(2, 11))
        L_f = m**2
        
        # Limit of g(x) chosen to ensure it is non-zero
        L_g = choice([i for i in range(-15, 16) if i != 0])
        
        # Randomize coefficients for the rational function in part (d)
        c3 = choice([2, 3, 4, 5]) * choice([-1, 1])
        c4 = choice([2, 3, 4, 5]) * choice([-1, 1])
        c5 = choice([1, 2, 3, 4, 5]) * choice([-1, 1])
        
        # Ensure the denominator for part (d) does not evaluate to zero
        if c5 == L_f:
            c5 += 1
            
        # --- Part (a): Linear Combination ---
        sign_a = choice([-1, 1])
        op_a = "-" if sign_a == -1 else "+"
        ans_a = L_f + sign_a * L_g
        L_g_str = f"({L_g})" if L_g < 0 else str(L_g)
        eval_a = f"{L_f} {op_a} {L_g_str}"
        lim_a = rf"\displaystyle \lim_{{x \to {c_str}}} [f(x) {op_a} g(x)]"
        
        # --- Part (b): Product ---
        ans_b = L_f * L_g
        eval_b = f"{L_f} \cdot {L_g_str}"
        lim_b = rf"\displaystyle \lim_{{x \to {c_str}}} [f(x) \cdot g(x)]"
        
        # --- Part (c): Radical / Quotient ---
        ans_c = Integer(m) / Integer(L_g)
        eval_c = rf"\frac{{\sqrt{{{L_f}}}}}{{{L_g}}}"
        lim_c = rf"\displaystyle \lim_{{x \to {c_str}}} \left[ \frac{{\sqrt{{f(x)}}}}{{g(x)}} \right]"
        
        # --- Part (d): Rational Function ---
        ans_d_expr = (Integer(c3) * Integer(L_f) + Integer(c4) * Integer(L_g)) / Integer(c5 - L_f)
        
        term2_d = f"+ {c4}g(x)" if c4 > 0 else f"- {abs(c4)}g(x)"
        num_d = f"{c3}f(x) {term2_d}"
        lim_d = rf"\displaystyle \lim_{{x \to {c_str}}} \left[ \frac{{{num_d}}}{{{c5} - f(x)}} \right]"
        
        op_d_eval = "+" if c4 > 0 else "-"
        num_d_eval = f"{c3}({L_f}) {op_d_eval} {abs(c4)}({L_g})"
        
        # Dynamically constructing the outtro to satisfy the Zero-Text Rule
        outtro = (
            f"<outtro>\n"
            f"    <p><m>{lim_a} = {eval_a} = {ans_a}</m></p>\n"
            f"    <p><m>{lim_b} = {eval_b} = {ans_b}</m></p>\n"
            f"    <p><m>{lim_c} = {eval_c} = {latex(ans_c)}</m></p>\n"
            f"    <p><m>{lim_d} = \\frac{{{num_d_eval}}}{{{c5} - {L_f}}} = {latex(ans_d_expr)}</m></p>\n"
            f"</outtro>"
        )

        return {
            "c": c_str,
            "L_f": L_f,
            "L_g": L_g,
            "lim_a": lim_a,
            "lim_b": lim_b,
            "lim_c": lim_c,
            "lim_d": lim_d,
            "outtro": outtro
        }