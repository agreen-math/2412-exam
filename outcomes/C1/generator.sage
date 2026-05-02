from sage.all import *
from random import randint, choice

class Generator(BaseGenerator):
    def data(self):
        x = var('x')
        h = var('h')

        a = randint(1, 6)
        b = randint(-9, 9)
     
        while b == 0:
            b = randint(-9, 9)
            
        f_expr = a * x**2 + b
        f_tex = rf"f(x) = {latex(f_expr)}"

        step1_sub = rf"{a}(x+h)^2"
        if b > 0: 
            step1_sub += rf" + {b}"
        else:     
            step1_sub += rf" - {abs(b)}"
        
        step2_expand = rf"{a}(x^2 + 2xh + h^2)"
        if b > 0: 
            step2_expand += rf" + {b}"
        else:     
            step2_expand += rf" - {abs(b)}"
        
        dist_poly = a*x**2 + 2*a*x*h + a*h**2 + b
        step3_dist = latex(dist_poly)
        
        step4_num_setup = rf"({step3_dist}) - ({latex(f_expr)})"
        
        num_simp_poly = 2*a*x*h + a*h**2
        step5_num_simp = latex(num_simp_poly)
        
        inner_factor = 2*a*x + a*h
        step6_factor = rf"h({latex(inner_factor)})"
        
        final_ans = latex(inner_factor)

        return {
            "f_tex": f_tex,
            "step1_sub": step1_sub,
            "step2_expand": step2_expand,
            "step3_dist": step3_dist,
            "step4_num_setup": step4_num_setup,
            "step5_num_simp": step5_num_simp,
            "step6_factor": step6_factor,
            "final_ans": final_ans
        }