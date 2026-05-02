import argparse
import re
import sys

# ==========================================
# 1. PARSING CORE LOGIC
# ==========================================

def get_braced_content(text, start_index=0):
    balance = 1
    i = start_index + 1
    while i < len(text) and balance > 0:
        if text[i] == '{': balance += 1
        elif text[i] == '}': balance -= 1
        i += 1
    if balance == 0:
        return text[start_index+1 : i-1], i
    return "", start_index + 1

def clean_solutions(content):
    sols = []
    for match in re.finditer(r'\\stxOuttro\s*\{', content):
        sol_content, _ = get_braced_content(content, match.end() - 1)
        sol_content = re.sub(r'^\s*SOLUTION:?\s*', '', sol_content, flags=re.IGNORECASE | re.MULTILINE).strip()
        sols.append(sol_content)
    return "\n\n".join(sols)

def parse_checkit_item(raw_block):
    match = re.search(r'\\stxKnowl\s*\{', raw_block)
    if not match: return None
    outer_content, _ = get_braced_content(raw_block, match.end() - 1)

    sub_knowl_iter = list(re.finditer(r'\\item\s*\\stxKnowl\s*\{', outer_content))
    
    if sub_knowl_iter:
        intro_text = outer_content[:sub_knowl_iter[0].start()].strip()
        intro_text = re.sub(r'\\begin\s*\{enumerate\}', '', intro_text).strip()
        
        sub_items = []
        for m in sub_knowl_iter:
            content, _ = get_braced_content(outer_content, m.end() - 1)
            sol = clean_solutions(content)
            q_parts = re.split(r'\\stxOuttro\s*\{', content)
            sub_items.append({'content': q_parts[0].strip(), 'solution': sol})
            
        return {'type': 'multi', 'intro': intro_text, 'sub_items': sub_items, 'raw': raw_block}
    else:
        sol = clean_solutions(outer_content)
        q_parts = re.split(r'\\stxOuttro', outer_content)
        return {'type': 'single', 'content': q_parts[0].strip(), 'solution': sol, 'raw': raw_block}

# ==========================================
# 2. SAFE TEXT & MATH EXTRACTORS
# ==========================================

def get_item_text(item):
    if item.get('type') == 'multi':
        text = item.get('intro', '')
        for sub in item.get('sub_items', []):
            text += " " + sub.get('content', '')
        return text
    return item.get('content', '')

def get_item_solution(item):
    if item.get('type') == 'multi':
        sols = [sub.get('solution', '') for sub in item.get('sub_items', [])]
        return "\n\n".join(sols)
    return item.get('solution', '')

def extract_all_math(text):
    math_matches = re.findall(r'\\\[(.*?)\\\]|\\\((.*?)\\\)', text, re.DOTALL)
    return [m[0].strip() if m[0] else m[1].strip() for m in math_matches]

def format_math(math_string):
    # Prevent double-wrapping of \displaystyle
    if r'\displaystyle' in math_string:
        return r"\(" + math_string + r"\)"
    return r"\(\displaystyle{ " + math_string + r" }\)"

def get_math(text, index):
    maths = extract_all_math(text)
    if index < len(maths): return format_math(maths[index])
    return r"\(\displaystyle{ [\text{MATH MISSING}] }\)"

def extract_tikz(text):
    match = re.search(r'\\begin\s*\{tikzpicture\}.*?\\end\s*\{tikzpicture\}', text, re.DOTALL)
    return match.group(0) if match else "GRAPH MISSING"

def format_solution(sol_text):
    if not sol_text: return ""
    return f"\n\\begin{{solution}}\n{sol_text}\n\\end{{solution}}\n"

# ==========================================
# 3. CUSTOM PRECALC TEMPLATE BUILDERS
# ==========================================

def build_generic(item, pts=5):
    text = get_item_text(item)
    sol = get_item_solution(item)
    return f"\\question[{pts}] Evaluate, simplify, or solve.\\\\ \\\\ " + get_math(text, 0) + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sol)

def build_c1_diff_quotient(item):
    text = get_item_text(item)
    sol = get_item_solution(item)
    maths = extract_all_math(text)
    # The first math is usually the DQ formula, the second is the actual function.
    func = format_math(maths[1]) if len(maths) > 1 else format_math(maths[-1]) if maths else "MISSING"
    return r"\question[10] Evaluate and simplify the difference quotient, \(\displaystyle{\frac{f(x+h)-f(x)}{h}}\), for the function.\\ \\ " + func + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sol)

def build_triangle_question(item, pts=5):
    text = get_item_text(item)
    sol = get_item_solution(item)
    
    # Intelligently extract just the measurements instead of the Triangle label
    match = re.search(r'Triangle .*? satisfies (.*?)\.', text)
    if match:
        measurements = match.group(1).replace(r'\(', '').replace(r'\)', '')
        formatted_math = format_math(measurements)
    else:
        maths = extract_all_math(text)
        formatted_math = format_math(maths[1]) if len(maths) > 1 else format_math(maths[0]) if maths else "MISSING"
        
    return f"\\question[{pts}] Solve the triangle for all missing sides and angles. If more than one triangle is possible, find \\textbf{{all}} solutions.\\\\ \\\\ " + formatted_math + "\n\\vspace*{\\stretch{1}}" + format_solution(sol)

def build_c9_word_problem(item):
    text = get_item_text(item).strip()
    sol = get_item_solution(item)
    return r"\question[3] " + text + "\n" + r"\vspace*{\stretch{2}}\answerline" + format_solution(sol)

def build_nc1_limits_graph(item):
    raw = item.get('raw', '')
    sol = get_item_solution(item)
    tikz = extract_tikz(raw)
    
    parts_latex = "\\begin{parts}\n"
    if item.get('type') == 'multi' and len(item.get('sub_items', [])) > 0:
        first_sub = item['sub_items'][0]['content']
        limit_parts = extract_all_math(first_sub)
        for math_var in limit_parts:
            # Skip the 'x = -1' prefix instruction, grab only the actual limit statements
            if 'x =' in math_var or 'x=' in math_var: continue
            parts_latex += f"\\part {format_math(math_var)} = \\vspace{{.15in}} \\answerline \n"
    parts_latex += "\\end{parts}"
    
    return r"\question[8] Evaluate the given limits based on the graph of $f(x)$." + "\n\\begin{center}\n" + tikz + "\n\\end{center}\n" + parts_latex + format_solution(sol)

def build_nc2_exact_values(item):
    text = get_item_text(item)
    sol = get_item_solution(item)
    maths = extract_all_math(text)
    
    parts_latex = "\\begin{multicols}{2}\n\\begin{parts}\n"
    for m in maths:
        parts_latex += f"\\part {format_math(m)} \\vspace{{36pt}} \\answerline \n"
    parts_latex += "\\end{parts}\n\\end{multicols}"
    
    return r"\question[6] Evaluate the exact values." + "\n" + parts_latex + format_solution(sol)

def build_nc3_trig_eq(item):
    text = get_item_text(item)
    sol = get_item_solution(item)
    maths = extract_all_math(text)
    
    parts_latex = "\\begin{multicols}{2}\n\\begin{parts}\n"
    for m in maths:
        parts_latex += f"\\part {format_math(m)} \\vspace{{\\stretch{{1}}}} \\answerline \n"
    parts_latex += "\\end{parts}\n\\end{multicols}"
    
    return r"\question[12] Solve the following trigonometric equations." + "\n" + parts_latex + format_solution(sol)

def build_nc4_sinusoidal(item):
    text = get_item_text(item)
    sol = get_item_solution(item)
    maths = extract_all_math(text)
    
    func = format_math(maths[0]) if maths else r"\(\displaystyle{ [\text{MATH MISSING}] }\)"
    
    # Robustly pluck the properties directly from the solution block
    def get_prop(name):
        m = re.search(rf'{name}[\s\w:]*(?:\\}})?\s*([^\\]+?)(?:\\\)|\n|$)', sol, re.IGNORECASE)
        if m: return format_math(m.group(1).strip())
        return r"\(\displaystyle{ [MISSING] }\)"
        
    amp = get_prop("Amplitude")
    if "[MISSING]" in amp: amp = get_prop("Vertical Dilation")
    per = get_prop("Period")
    ps = get_prop("Phase Shift")
    
    table = f"""\\begin{{center}}
{{\\renewcommand{{\\arraystretch}}{{2}}
\\begin{{tabular}}{{|c|p{{2in}}|}}
\\hline
Period & {per} \\\\ \\hline
Vertical Dilation & {amp} \\\\ \\hline
Phase Shift & {ps} \\\\ \\hline
\\end{{tabular}}}}
\\end{{center}}"""
    
    return r"\question[6] Identify the properties of the sinusoidal function:\\ \\ " + func + "\n" + table + format_solution(sol)

def build_nc9_and_nc10(item):
    text = get_item_text(item)
    sol = get_item_solution(item)
    
    pt_a_match = re.search(r'A:\s*\\\((.*?)\\\)', text)
    pt_b_match = re.search(r'B:\s*\\\((.*?)\\\)', text)
    
    pt_a = format_math(pt_a_match.group(1)) if pt_a_match else r"\(\displaystyle{ [\text{MATH MISSING}] }\)"
    pt_b = format_math(pt_b_match.group(1)) if pt_b_match else r"\(\displaystyle{ [\text{MATH MISSING}] }\)"
    
    q9 = r"\question[4] Plot the polar coordinates: " + pt_a + r" and " + pt_b + r"." + "\n" + r"\vspace*{\stretch{1}}"
    q10 = r"\question[4] Convert the polar coordinates to rectangular coordinates: " + pt_a + r" and " + pt_b + r"." + "\n" + r"\vspace*{\stretch{1}}\answerline" + format_solution(sol)
    
    return q9, q10

def build_nc11_to_nc13(item):
    sub_items = item.get('sub_items', [])
    
    q11_content = sub_items[0].get('content', 'MISSING') if len(sub_items) > 0 else "MISSING"
    q11 = r"\question[3] " + q11_content + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sub_items[0].get('solution', '') if len(sub_items)>0 else "")

    q12_content = sub_items[1].get('content', 'MISSING') if len(sub_items) > 1 else "MISSING"
    q12 = r"\question[3] " + q12_content + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sub_items[1].get('solution', '') if len(sub_items)>1 else "")

    q13_content = sub_items[2].get('content', 'MISSING') if len(sub_items) > 2 else "MISSING"
    q13 = r"\question[1] " + q13_content + "\n\\vspace*{\\stretch{1}}\\answerline" + format_solution(sub_items[2].get('solution', '') if len(sub_items)>2 else "")

    return q11, q12, q13

# ==========================================
# 4. MAIN COMPILATION LOOP
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

    # Define exact page breaks here. (0-indexed)
    CALC_PAGE_BREAKS = [] 
    NONCALC_PAGE_BREAKS = []

    with open(args.checkit, 'r', encoding='utf-8') as f:
        checkit_content = f.read()

    raw_blocks = re.split(r'\\item\s*%%%%% SpaTeXt Commands %%%%%', checkit_content)
    if len(raw_blocks) > 0: raw_blocks = raw_blocks[1:]

    q_items = []
    for block in raw_blocks:
        if '\\stxKnowl' in block:
            parsed = parse_checkit_item(block)
            if parsed: q_items.append(parsed)

    while len(q_items) < 21:
        q_items.append({'type': 'single', 'content': 'MISSING', 'solution': '', 'raw': ''})

    calc_questions = [
        build_c1_diff_quotient(q_items[0]),  # C1 
        build_generic(q_items[1]),           # C2
        build_generic(q_items[2]),           # C3
        build_generic(q_items[3]),           # C4
        build_triangle_question(q_items[4]), # C5
        build_generic(q_items[5]),           # C6
        build_generic(q_items[6]),           # C7
        build_triangle_question(q_items[7]), # C8
        build_c9_word_problem(q_items[8]),   # C9
        build_generic(q_items[9]),           # C10
        build_generic(q_items[10])           # C11
    ]

    q9, q10 = build_nc9_and_nc10(q_items[19])
    
    # Correctly mapped to item 20 (CheckIt #21)
    q11, q12, q13 = build_nc11_to_nc13(q_items[20])

    noncalc_questions = [
        build_nc1_limits_graph(q_items[11]), # NC1
        build_nc2_exact_values(q_items[12]), # NC2
        build_nc3_trig_eq(q_items[13]),      # NC3
        build_nc4_sinusoidal(q_items[14]),   # NC4
        build_generic(q_items[15]),          # NC5
        build_generic(q_items[16]),          # NC6
        build_generic(q_items[17]),          # NC7
        build_generic(q_items[18]),          # NC8
        q9,                                  # NC9
        q10,                                 # NC10
        q11,                                 # NC11
        q12,                                 # NC12
        q13                                  # NC13
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