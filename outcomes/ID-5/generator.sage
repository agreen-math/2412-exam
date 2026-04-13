from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # Generate relatively prime A and B to ensure fully reduced fractions
        configs = []
        for a in range(1, 6):
            for b in range(1, 6):
                if gcd(a, b) == 1:
                    configs.append((a, b))
        
        A, B = random.choice(configs)
        
        # Format the algebraic components for LaTeX
        Au_str = "u" if A == 1 else f"{A}u"
        Asq_u2_str = "u^2" if A == 1 else f"{A**2}u^2"
        
        if B == 1:
            arg_tex = Au_str
            tan_ratio = rf"\frac{{{Au_str}}}{{1}}"
        else:
            arg_tex = rf"\frac{{{Au_str}}}{{{B}}}"
            tan_ratio = arg_tex
            
        r_tex = rf"\sqrt{{{Asq_u2_str} + {B**2}}}"
        r_sq_tex = rf"{Asq_u2_str} + {B**2}"
        
        # Construct the prompt strictly for cosine
        prompt_tex = rf"\cos\left(2\tan^{{-1}}\left({arg_tex}\right)\right)"
        
        # Preliminary Steps: Geometric Setup
        prelim1 = rf"\text{{Let }} \theta = \tan^{{-1}}\left({arg_tex}\right) \implies \tan\theta = {tan_ratio} = \frac{{y}}{{x}}"
        prelim2 = rf"r = \sqrt{{x^2 + y^2}} = \sqrt{{({B})^2 + ({Au_str})^2}} = {r_tex}"
        
        cos_val_num = f"{B}"
        cos_val_tex = rf"\frac{{{cos_val_num}}}{{{r_tex}}}"
        
        prelim3 = rf"\cos\theta = \frac{{x}}{{r}} = {cos_val_tex}"
        
        # Double-Angle Identity Substitution and Algebra
        step1 = r"\cos(2\theta) = 2\cos^2\theta - 1"
        step2 = rf"= 2\left({cos_val_tex}\right)^2 - 1"
        
        two_B_sq = 2 * B**2
        step3 = rf"= 2 \cdot \frac{{{B**2}}}{{{r_sq_tex}}} - 1"
        step4 = rf"= \frac{{{two_B_sq}}}{{{r_sq_tex}}} - \frac{{{r_sq_tex}}}{{{r_sq_tex}}}"
        step5 = rf"= \frac{{{two_B_sq} - {Asq_u2_str} - {B**2}}}{{{r_sq_tex}}}"
        
        final_num_tex = f"{B**2} - {Asq_u2_str}"
        final_ans = rf"\frac{{{final_num_tex}}}{{{r_sq_tex}}}"
        final_sol = rf"\boxed{{{final_ans}}}"
        
        # Assemble the outtro using the Zero-Text Rule
        outtro_lines = [
            f"    <p><m>{prelim1}</m></p>",
            f"    <p><m>{prelim2}</m></p>",
            f"    <p><m>{prelim3}</m></p>",
            f"    <p><m>{step1}</m></p>",
            f"    <p><m>{step2}</m></p>",
            f"    <p><m>{step3}</m></p>",
            f"    <p><m>{step4}</m></p>",
            f"    <p><m>{step5}</m></p>",
            f"    <p><m>{final_sol}</m></p>"
        ]
            
        outtro = "<outtro>\n" + "\n".join(outtro_lines) + "\n</outtro>"
        
        return {
            "prompt": prompt_tex,
            "outtro": outtro
        }