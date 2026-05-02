from sage.all import *
from random import choice, randint

class Generator(BaseGenerator):
    def data(self):
        m_pow = choice([1, 2, 3])
        n_root = choice([2, 3, 4])
        p_pow = choice([2, 3, 4])

        m_val = randint(2, 9)
        n_val = n_root * randint(2, 6) 
        p_val = randint(2, 9)

        m_part = rf"m^{{{m_pow}}}" if m_pow > 1 else "m"
        n_part = rf"\sqrt[{n_root}]{{n-1}}" if n_root > 2 else r"\sqrt{n-1}"
        num = rf"{m_part}{n_part}"
        den = rf"p^{{{p_pow}}}" if p_pow > 1 else "p"
        
        expr_latex = rf"\log_b\left(\frac{{{num}}}{{{den}}}\right)"

        term1_str = rf"{m_pow}({m_val})" if m_pow > 1 else str(m_val)
        term2_str = rf"\frac{{1}}{{{n_root}}}({n_val})"
        term3_str = rf"{p_pow}({p_val})" if p_pow > 1 else str(p_val)
        
        step1 = rf"{term1_str} + {term2_str} - {term3_str}"

        val1 = m_pow * m_val
        val2 = n_val // n_root
        val3 = p_pow * p_val

        step2 = rf"{val1} + {val2} - {val3}"
        
        final_sol = val1 + val2 - val3

        solution_steps = (
            rf"    <p><m>{step1}</m></p>\n"
            rf"    <p><m>{step2}</m></p>\n"
            rf"    <p><m>\boxed{{{final_sol}}}</m></p>\n"
        )

        return {
            "m_val": m_val,
            "n_val": n_val,
            "p_val": p_val,
            "expr_latex": expr_latex,
            "solution_steps": solution_steps
        }