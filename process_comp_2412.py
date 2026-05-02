import argparse
import re
import sys

# ==========================================
# 1. CORE UTILITIES & VACUUM EXTRACTORS
# ==========================================

def get_braced_content(text, start_index):
    """Extracts content within nested LaTeX braces."""
    if start_index >= len(text) or text[start_index] != "{":
        return None, start_index
    count = 1
    for i in range(start_index + 1, len(text)):
        if text[i] == "{": count += 1
        elif text[i] == "}": count -= 1
        if count == 0:
            return text[start_index + 1:i], i + 1
    return None, len(text)

def parse_checkit_item(raw_block):
    """Surgically splits the clean prompt data from the outtro solutions."""
    match = re.search(r'\\stxKnowl\s*\{', raw_block)
    if not match: return "", ""
    
    outer_content, _ = get_braced_content(raw_block, match.end() - 1)
    
    outtro_match = re.search(r'\\stxOuttro\s*\{', outer_content)
    if outtro_match:
        prompt_text = outer_content[:outtro_match.start()].strip()
        sol_content, _ = get_braced_content(outer_content, outtro_match.end() - 1)
        sol_content = re.sub(r'^\s*SOLUTION:?\s*', '', sol_content, flags=re.IGNORECASE | re.MULTILINE).strip()
        return prompt_text, sol_content
    
    return outer_content.strip(), ""

def extract_math(text):
    """Vacuums all math environments from the text block."""
    matches = re.findall(r'\\\[(.*?)\\\]|\\\((.*?)\\\)', text, re.DOTALL)
    return [m[0].strip() if m[0] else m[1].strip() for m in matches]

def format_math(math_string):
    """Wraps math in displaystyle, preventing double-wrapping."""
    if not math_string: return r"\(\displaystyle{ [\text{MISSING}] }\)"
    if r'\displaystyle' in math_string:
        return r"\(" + math_string + r"\)"
    return r"\(\displaystyle{ " + math_string + r" }\)"

def extract_tikz(text):
    """Vacuums the TikZ picture environment."""
    match = re.search(r'\\begin\s*\{tikzpicture\}.*?\\end\s*\{tikzpicture\}', text, re.DOTALL)
    return match.group(0) if match else "GRAPH MISSING"

def format_solution(sol_text):
    if not sol_text: return ""
    return f"\n\\begin{{solution}}\n{sol_text}\n\\end{{solution}}\n"

def extract_comment(tag, text):
    """Snaps exactly to the hidden anchor variable in the CheckIt output."""
    m = re.search(rf'%\s*\[{tag}\]\s*(.*)', text)
    return m.group(1).strip() if m else r"[\text{MISSING}]"

def extract_all_comments(text):
    """Finds all hidden anchors and returns them as a list of tuples."""
    return re.findall(r'%\s*\[(.*?)\]\s*(.*)', text)

# ==========================================
# 2. CUSTOM PRECALC TEMPLATE BUILDERS
# ==========================================

def build_generic(clean_text, sol, pts=5):
    maths = extract_math(clean_text)
    func = format_math(maths[0]) if maths else r"\(\displaystyle{ [\text{MATH MISSING}] }\)"
    return f"\\question[{pts}] Evaluate, simplify, or solve.\\\\ \\\\ " + func + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sol)

def build_c1_diff_quotient(clean_text, sol):
    maths = extract_math(clean_text)
    func = format_math(maths[0]) if maths else "MISSING"
    return r"\question[10] Evaluate and simplify the difference quotient, \(\displaystyle{\frac{f(x+h)-f(x)}{h}}\), for the function.\\ \\ " + func + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sol)

def build_triangle(clean_text, sol, pts=5):
    comments = extract_all_comments(clean_text)
    if comments:
        parts = [f"\\({k} = {v}\\)" for k, v in comments]
        joined = ", ".join(parts[:-1]) + ", and " + parts[-1] if len(parts) > 1 else parts[0]
        math_str = f"Triangle \\(ABC\\) satisfies {joined}."
    else:
        maths = extract_math(clean_text)
        math_str = format_math(maths[0]) if maths else "MISSING"
        
    return f"\\question[{pts}] Solve the triangle for all missing sides and angles. If more than one triangle is possible, find \\textbf{{all}} solutions.\\\\ \\\\ " + math_str + "\n\\vspace*{\\stretch{1}}" + format_solution(sol)

def build_word_problem(clean_text, sol):
    return r"\question[3] " + clean_text + "\n\\vspace*{\\stretch{2}}\\answerline" + format_solution(sol)

def build_nc1_rational_graph(clean_text, sol):
    """Ported directly from 1314 process_comp.py"""
    maths = extract_math(clean_text)
    func = format_math(maths[0]) if maths else r"\(\displaystyle{ [\text{MATH MISSING}] }\)"
    
    y_int = extract_comment('y-int', clean_text)
    x_int = extract_comment('x-int', clean_text)
    va = extract_comment('VA', clean_text)
    ha = extract_comment('HA', clean_text)
    holes = extract_comment('Holes', clean_text)
    
    q_latex = r"\question[12] Identify the given features of the rational function. If a feature does not exist, write \textbf{None}. Then, sketch the graph on the coordinate plane provided. Be sure to graph asymptotes as dashed lines and clearly plot the intercepts and any holes.\\ \\ " + func + "\n"
    
    q_latex += r"""
\begin{multicols}{2}
{\renewcommand{\arraystretch}{2}
\begin{tabular}{|c|p{1.5in}|}\hline
    $y$-intercept & """ + f"\\(\\displaystyle{{ {y_int} }}\\)" + r""" \\ \hline
    $x$-intercept(s) & """ + f"\\(\\displaystyle{{ {x_int} }}\\)" + r""" \\ \hline
    Vertical Asymptote(s) & """ + f"\\(\\displaystyle{{ {va} }}\\)" + r""" \\ \hline
    Horizontal Asymptote & """ + f"\\(\\displaystyle{{ {ha} }}\\)" + r""" \\ \hline
    Hole(s) & """ + f"\\(\\displaystyle{{ {holes} }}\\)" + r""" \\ \hline
\end{tabular}}

\vspace{\stretch{1}}

\columnbreak
\includegraphics[width=3.5in]{blankgraph.PNG}

\end{multicols}"""
    return q_latex + format_solution(sol)

def build_nc2_exact_values(clean_text, sol):
    maths = extract_math(clean_text)
    parts_latex = "\\begin{multicols}{2}\n\\begin{parts}\n"
    for m in maths:
        parts_latex += f"\\part {format_math(m)} \\vspace{{36pt}} \\answerline \n"
    parts_latex += "\\end{parts}\n\\end{multicols}"
    return r"\question[6] Evaluate the exact values." + "\n" + parts_latex + format_solution(sol)

def build_nc3_trig_eq(clean_text, sol):
    maths = extract_math(clean_text)
    parts_latex = "\\begin{multicols}{2}\n\\begin{parts}\n"
    for m in maths:
        parts_latex += f"\\part {format_math(m)} \\vspace{{\\stretch{{1}}}} \\answerline \n"
    parts_latex += "\\end{parts}\n\\end{multicols}"
    return r"\question[12] Solve the following trigonometric equations." + "\n" + parts_latex + format_solution(sol)

def build_nc4_sinusoidal(clean_text, sol):
    func = extract_comment('FUNC', clean_text)
    amp = extract_comment('AMP', clean_text)
    per = extract_comment('PER', clean_text)
    ps = extract_comment('PS', clean_text)
    
    table = f"""\\begin{{center}}
{{\\renewcommand{{\\arraystretch}}{{2}}
\\begin{{tabular}}{{|c|p{{2in}}|}}
\\hline
Period & \\(\\displaystyle{{ {per} }}\\) \\\\ \\hline
Vertical Dilation & \\(\\displaystyle{{ {amp} }}\\) \\\\ \\hline
Phase Shift & \\(\\displaystyle{{ {ps} }}\\) \\\\ \\hline
\\end{{tabular}}}}
\\end{{center}}"""
    return r"\question[6] Identify the properties of the sinusoidal function:\\ \\ \(\displaystyle{ " + func + r" }\)" + "\n" + table + format_solution(sol)

def build_nc9_and_nc10(clean_text, sol):
    pt_a = extract_comment('A', clean_text)
    pt_b = extract_comment('B', clean_text)
    
    q9 = r"\question[4] Plot the polar coordinates: \(\displaystyle{ " + pt_a + r" }\) and \(\displaystyle{ " + pt_b + r" }\)." + "\n\\vspace*{\\stretch{1}}"
    q10 = r"\question[4] Convert the polar coordinates to rectangular coordinates: \(\displaystyle{ " + pt_a + r" }\) and \(\displaystyle{ " + pt_b + r" }\)." + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sol)
    
    return q9, q10

def build_nc11_to_nc13(clean_text, sol):
    tikz = extract_tikz(clean_text)
    maths = extract_math(clean_text)
    
    parts_latex = "\\begin{parts}\n"
    for m in maths[0:4]:
        parts_latex += f"\\part {format_math(m)} = \\vspace{{.15in}} \\answerline \n"
    parts_latex += "\\end{parts}"
    
    q11 = r"\question[8] Evaluate the given limits based on the graph of $f(x)$." + "\n\\begin{center}\n" + tikz + "\n\\end{center}\n" + parts_latex + format_solution(sol)
    
    q12_math = format_math(maths[4]) if len(maths) > 4 else "MISSING"
    q12 = r"\question[3] Evaluate.\\\\ \\\\ " + q12_math + "\n\\vspace*{\\stretch{1}}\\answerline"
    
    chunks = [c.strip() for c in clean_text.split('\n\n') if c.strip()]
    q13_text = chunks[-1] if chunks else "MISSING"
    q13 = r"\question[1] " + q13_text + "\n\\vspace*{\\stretch{1}}\\answerline"
    
    # We assign the answer key to the final question
    return q11, q12, q13 + format_solution(sol)

# ==========================================
# 3. MAIN COMPILATION LOOP
# ==========================================

def apply_page_breaks(questions, breaks):
    out = ""
    for i, q in enumerate(questions):
        out += q + "\n\n"
        if i in breaks:
            out += "\\newpage\n\n"
    return out

def main():
    parser = argparse.ArgumentParser(description="CheckIt to Department Parser - PRECALC (2412)")
    parser.add_argument("--checkit", required=True, help="Input CheckIt .tex file")
    parser.add_argument("--template", required=True, help="Input Department Template .tex file")
    parser.add_argument("--out", required=True, help="Output .tex file")
    args = parser.parse_args()

    # E.g., [2, 5] places a \newpage after the 3rd and 6th question of a section
    CALC_PAGE_BREAKS = [] 
    NONCALC_PAGE_BREAKS = []

    with open(args.checkit, 'r', encoding='utf-8') as f:
        checkit_content = f.read()

    raw_blocks = re.split(r'\\item\s*%%%%% SpaTeXt Commands %%%%%', checkit_content)
    if len(raw_blocks) > 0: raw_blocks = raw_blocks[1:]

    q_items = []
    for block in raw_blocks:
        if '\\stxKnowl' in block:
            prompt, sol = parse_checkit_item(block)
            q_items.append({'text': prompt, 'sol': sol})

    # Pad array safely in case of compile failure
    while len(q_items) < 21:
        q_items.append({'text': 'MISSING', 'sol': ''})

    # Execute Template Builders
    calc_questions = [
        build_c1_diff_quotient(q_items[0]['text'], q_items[0]['sol']),  # C1
        build_generic(q_items[1]['text'], q_items[1]['sol']),           # C2
        build_generic(q_items[2]['text'], q_items[2]['sol']),           # C3
        build_generic(q_items[3]['text'], q_items[3]['sol']),           # C4
        build_triangle(q_items[4]['text'], q_items[4]['sol']),          # C5
        build_generic(q_items[5]['text'], q_items[5]['sol']),           # C6
        build_generic(q_items[6]['text'], q_items[6]['sol']),           # C7
        build_triangle(q_items[7]['text'], q_items[7]['sol']),          # C8
        build_word_problem(q_items[8]['text'], q_items[8]['sol']),      # C9
        build_generic(q_items[9]['text'], q_items[9]['sol']),           # C10
        build_generic(q_items[10]['text'], q_items[10]['sol'])          # C11
    ]

    q9, q10 = build_nc9_and_nc10(q_items[19]['text'], q_items[19]['sol'])
    q11, q12, q13 = build_nc11_to_nc13(q_items[20]['text'], q_items[20]['sol'])

    noncalc_questions = [
        build_nc1_rational_graph(q_items[11]['text'], q_items[11]['sol']), # NC1
        build_nc2_exact_values(q_items[12]['text'], q_items[12]['sol']),   # NC2
        build_nc3_trig_eq(q_items[13]['text'], q_items[13]['sol']),        # NC3
        build_nc4_sinusoidal(q_items[14]['text'], q_items[14]['sol']),     # NC4
        build_generic(q_items[15]['text'], q_items[15]['sol']),            # NC5
        build_generic(q_items[16]['text'], q_items[16]['sol']),            # NC6
        build_generic(q_items[17]['text'], q_items[17]['sol']),            # NC7
        build_generic(q_items[18]['text'], q_items[18]['sol']),            # NC8
        q9,                                                                # NC9
        q10,                                                               # NC10
        q11,                                                               # NC11
        q12,                                                               # NC12
        q13                                                                # NC13
    ]

    with open(args.template, 'r', encoding='utf-8') as f:
        template_content = f.read()

    parts = re.split(r'\\begin\s*\{questions\}|\\end\s*\{questions\}', template_content)
    
    if len(parts) >= 5:
        calc_out = parts[0] + r"\begin{questions}" + "\n\n" + apply_page_breaks(calc_questions, CALC_PAGE_BREAKS) + r"\end{questions}"
        noncalc_out = parts[2] + r"\begin{questions}" + "\n\n" + apply_page_breaks(noncalc_questions, NONCALC_PAGE_BREAKS) + r"\end{questions}" + parts[4]
        final_latex = calc_out + noncalc_out
    else:
        final_latex = parts[0] + r"\begin{questions}" + "\n\n" + apply_page_breaks(calc_questions + noncalc_questions, CALC_PAGE_BREAKS) + r"\end{questions}" + parts[2]

    with open(args.out, 'w', encoding='utf-8') as f:
        f.write(final_latex)

    print(f"Successfully processed PreCalculus exam. Output saved to {args.out}")

if __name__ == "__main__":
    main()