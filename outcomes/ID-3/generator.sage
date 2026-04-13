from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        valid = False
        while not valid:
            # Target unit circle angles in degrees
            theta = random.choice([30, 45, 60, 90, 120, 135, 150, 180, 210, 225, 240, 270, 300, 315, 330])
            func = random.choice(['sin', 'cos'])
            op = random.choice(['+', '-'])
            
            # Generate starting angles alpha and beta
            if op == '+':
                if theta <= 22:
                    continue  # Ensure theta is large enough to split nicely
                alpha = random.randint(11, theta - 11)
                beta = theta - alpha
            else:
                beta = random.randint(11, 79)
                alpha = theta + beta
                
            # Filter out multiples of 15 so students can't easily evaluate them directly
            if alpha % 15 != 0 and beta % 15 != 0:
                valid = True
                
        # Build the expanded expression for the prompt
        if func == 'sin':
            if op == '+':
                expr_latex = rf"\sin {alpha}^\circ \cos {beta}^\circ + \cos {alpha}^\circ \sin {beta}^\circ"
            else:
                expr_latex = rf"\sin {alpha}^\circ \cos {beta}^\circ - \cos {alpha}^\circ \sin {beta}^\circ"
        else: # func == 'cos'
            if op == '+':
                expr_latex = rf"\cos {alpha}^\circ \cos {beta}^\circ - \sin {alpha}^\circ \sin {beta}^\circ"
            else:
                expr_latex = rf"\cos {alpha}^\circ \cos {beta}^\circ + \sin {alpha}^\circ \sin {beta}^\circ"
                
        # Step 1: Condense into the sum/difference identity format and simplify the angle
        step1 = rf"\{func}({alpha}^\circ {op} {beta}^\circ) = \{func}({theta}^\circ)"
        
        # Step 2: Use a dictionary to force perfect LaTeX formatting for the final exact value
        val_latex = {
            "sin": {
                30: r"\frac{1}{2}", 45: r"\frac{\sqrt{2}}{2}", 60: r"\frac{\sqrt{3}}{2}", 90: "1",
                120: r"\frac{\sqrt{3}}{2}", 135: r"\frac{\sqrt{2}}{2}", 150: r"\frac{1}{2}", 180: "0",
                210: r"-\frac{1}{2}", 225: r"-\frac{\sqrt{2}}{2}", 240: r"-\frac{\sqrt{3}}{2}", 270: "-1",
                300: r"-\frac{\sqrt{3}}{2}", 315: r"-\frac{\sqrt{2}}{2}", 330: r"-\frac{1}{2}"
            },
            "cos": {
                30: r"\frac{\sqrt{3}}{2}", 45: r"\frac{\sqrt{2}}{2}", 60: r"\frac{1}{2}", 90: "0",
                120: r"-\frac{1}{2}", 135: r"-\frac{\sqrt{2}}{2}", 150: r"-\frac{\sqrt{3}}{2}", 180: "-1",
                210: r"-\frac{\sqrt{3}}{2}", 225: r"-\frac{\sqrt{2}}{2}", 240: r"-\frac{1}{2}", 270: "0",
                300: r"\frac{1}{2}", 315: r"\frac{\sqrt{2}}{2}", 330: r"\frac{\sqrt{3}}{2}"
            }
        }
        
        exact_latex = val_latex[func][theta]
        final_sol = rf"\boxed{{{exact_latex}}}"
        
        # Assemble the outtro utilizing the Zero-Text Rule
        outtro = (
            f"<outtro>\n"
            f"    <p><m>{step1}</m></p>\n"
            f"    <p><m>{final_sol}</m></p>\n"
            f"</outtro>"
        )
        
        return {
            "expr": expr_latex,
            "outtro": outtro
        }