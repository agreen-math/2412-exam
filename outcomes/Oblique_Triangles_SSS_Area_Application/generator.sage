import random

class Generator(BaseGenerator):
    def data(self):
        # Enforce the Triangle Inequality Theorem to ensure valid geometry
        while True:
            a = random.randint(300, 600)
            b = random.randint(300, 600)
            c = random.randint(300, 600)
            if a + b > c and a + c > b and b + c > a:
                break
                
        # Calculate the semi-perimeter
        s_val = (a + b + c) / 2.0
        
        # Calculate the area using Heron's Formula
        # Cast to float to evaluate the symbolic expression for formatting
        area_val = float(sqrt(s_val * (s_val - a) * (s_val - b) * (s_val - c)))
        
        # Format the area to at most two decimal places, stripping trailing zeros
        formatted_area = f"{area_val:.2f}".rstrip('0').rstrip('.')
        
        # Define symbolic variables for rigorous LaTeX formatting
        s_var = var('s')
        A_var = var('A')
        
        # Construct the solution steps dynamically using raw f-strings
        solution_steps = (
            rf"    <p><m>{latex(s_var)} = \frac{{{a} + {b} + {c}}}{{2}} = {s_val:g}</m></p>\n"
            rf"    <p><m>{latex(A_var)} = \sqrt{{{latex(s_var)}({latex(s_var)}-{a})({latex(s_var)}-{b})({latex(s_var)}-{c})}}</m></p>\n"
            rf"    <p><m>{latex(A_var)} = \sqrt{{{s_val:g}({s_val - a:g})({s_val - b:g})({s_val - c:g})}}</m></p>\n"
            rf"    <p><m>{latex(A_var)} \approx {formatted_area}</m></p>\n"
        )
        
        return {
            "a": a,
            "b": b,
            "c": c,
            "solution_steps": solution_steps
        }