import random

class Generator(BaseGenerator):
    def data(self):
        t = var('t')
        x, y, u = var('x, y, u')
        
        # Randomize parameters for linear substitution
        a = choice([1, 2, 3, 4])
        m = choice([i for i in range(-5, 6) if i not in [0, 1]])
        c = a * m
        b = choice([i for i in range(-7, 8) if i != 0])
        trig_func = choice([sin, cos])
        
        # Construct parametric equations
        x_expr = a * trig_func(t)
        y_expr = c * trig_func(t) + b
        
        x_eq = (x == x_expr)
        y_eq = (y == y_expr)
        
        # Construct the outtro dynamically to satisfy the Zero-Text Rule
        outtro = f"<outtro>\n"
        
        if a != 1:
            step1 = (trig_func(t) == x / a)
            outtro += f"    <p><m>{latex(step1)}</m></p>\n"
            
            # Construct unsimplified substitution string
            y_sub = c * u + b
            fraction_latex = latex(x / a)
            step2_latex = r"y = " + latex(y_sub).replace('u', rf"\left({fraction_latex}\right)")
            outtro += f"    <p><m>{step2_latex}</m></p>\n"
        else:
            step1 = (trig_func(t) == x)
            outtro += f"    <p><m>{latex(step1)}</m></p>\n"
            
            # Construct unsimplified substitution string
            y_sub = c * u + b
            step2_latex = r"y = " + latex(y_sub).replace('u', latex(x))
            outtro += f"    <p><m>{step2_latex}</m></p>\n"
        
        # Provide final simplified equation
        final_eq = (y == m * x + b)
        
        # Ensure redundant simplification steps are not displayed
        if a != 1:
            outtro += f"    <p><m>{latex(final_eq)}</m></p>\n"
        
        outtro += f"</outtro>"
        
        return {
            "x_eq": latex(x_eq),
            "y_eq": latex(y_eq),
            "outtro": outtro
        }