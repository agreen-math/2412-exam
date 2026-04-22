import random

class Generator(BaseGenerator):
    def data(self):
        # Apply a random shift to the entire base graph
        h = choice([-1, 0, 1])
        v = choice([-1, 0, 1])
        
        base_graph = choice([1, 2])
        
        if base_graph == 1:
            points = {
                "jump": {"x": -2+h, "L": 2+v, "R": -1+v, "lim": "DNE", "val": 2+v},
                "hole": {"x": 2+h, "L": 3+v, "R": 3+v, "lim": 3+v, "val": 1+v},
                "va":   {"x": 4+h, "L": "-\\infty", "R": "\\infty", "lim": "DNE", "val": "DNE"}
            }
            ends = {"-\\infty": 2+v, "\\infty": -1+v}
            
            graph_specific_tikz = (
                rf"\draw[thick, blue, <-] (-7.5, {2+v}) -- ({ -2+h }, {2+v});"
                rf"\draw[thick, blue] ({ -2+h }, {-1+v}) -- ({ 2+h }, {3+v});"
                rf"\draw[thick, blue, domain={2+h}:{3.8+h}, samples=50] plot (\x, {{ 4/(\x - ({4+h})) + ({5+v}) }});"
                rf"\draw[thick, blue, domain={4.2+h}:7.5, samples=50] plot (\x, {{ 2/(\x - ({4+h})) - 1 + ({v}) }});"
                rf"\fill[blue] ({ -2+h }, {2+v}) circle (4pt);"
                rf"\fill[white, draw=blue, thick] ({ -2+h }, {-1+v}) circle (4pt);"
                rf"\fill[white, draw=blue, thick] ({ 2+h }, {3+v}) circle (4pt);"
                rf"\fill[blue] ({ 2+h }, {1+v}) circle (4pt);"
                rf"\draw[dashed, thick] ({ 4+h }, -7.5) -- ({ 4+h }, 7.5);"
                rf"\draw[dashed, thick] (-7.5, {-1+v}) -- (7.5, {-1+v});"
            )
        else:
            points = {
                "hole": {"x": -3+h, "L": 1+v, "R": 1+v, "lim": 1+v, "val": "DNE"},
                "jump": {"x": 0+h,  "L": 4+v, "R": 0+v, "lim": "DNE", "val": 0+v},
                "va":   {"x": 3+h,  "L": "-\\infty", "R": "\\infty", "lim": "DNE", "val": "DNE"}
            }
            ends = {"-\\infty": "-\\infty", "\\infty": 2+v}
            
            graph_specific_tikz = (
                rf"\draw[thick, blue, domain=-7.5:{-3+h}, samples=50] plot (\x, {{ -0.5*(\x - ({-3+h}))^2 + ({1+v}) }});"
                rf"\draw[thick, blue, domain={-3+h}:{0+h}, samples=50] plot (\x, {{ -0.333333*(\x - ({0+h}))^2 + ({4+v}) }});"
                rf"\draw[thick, blue, domain={0+h}:{2.8+h}, samples=50] plot (\x, {{ 3/(\x - ({3+h})) + ({1+v}) }});"
                rf"\draw[thick, blue, domain={3.2+h}:7.5, samples=50] plot (\x, {{ 2/(\x - ({3+h})) + ({2+v}) }});"
                rf"\fill[white, draw=blue, thick] ({ -3+h }, {1+v}) circle (4pt);"
                rf"\fill[white, draw=blue, thick] ({ 0+h }, {4+v}) circle (4pt);"
                rf"\fill[blue] ({ 0+h }, {0+v}) circle (4pt);"
                rf"\draw[dashed, thick] ({ 3+h }, -7.5) -- ({ 3+h }, 7.5);"
                rf"\draw[dashed, thick] (-7.5, {2+v}) -- (7.5, {2+v});"
            )

        tikz_code = (
            rf"\begin{{tikzpicture}}[scale=0.55, baseline=(current bounding box.center)]"
            rf"\draw[lightgray, very thin, step=1] (-7.5,-7.5) grid (7.5,7.5);"
            rf"\draw[->, thick] (-7.5,0) -- (7.5,0) node[right] {{$x$}};"
            rf"\draw[->, thick] (0,-7.5) -- (0,7.5) node[above] {{$f(x)$}};"
            rf"\foreach \x in {{-7,...,-1,1,2,3,4,5,6,7}} {{ \draw (\x, 4pt) -- (\x, -4pt) node[below, fill=white, inner sep=1pt, font=\scriptsize] {{\x}}; }}"
            rf"\foreach \y in {{-7,...,-1,1,2,3,4,5,6,7}} {{ \draw (4pt, \y) -- (-4pt, \y) node[left, fill=white, inner sep=1pt, font=\scriptsize] {{\y}}; }}"
            rf"\clip (-7.5, -7.5) rectangle (7.5, 7.5);"
            + graph_specific_tikz +
            rf"\end{{tikzpicture}}"
        )

        # --- Part 1: 4-part limits at an interesting point ---
        p_focus = choice(["jump", "hole", "va"])
        c1 = points[p_focus]["x"]
        
        limit_a_q = rf"\displaystyle \lim_{{x \to {c1}^-}} f(x)"
        limit_b_q = rf"\displaystyle \lim_{{x \to {c1}^+}} f(x)"
        limit_c_q = rf"\displaystyle \lim_{{x \to {c1}}} f(x)"
        limit_d_q = rf"f({c1})"
        
        # --- Part 2: End Behavior ---
        end_choice = choice(["-\\infty", "\\infty"])
        lim2_q = rf"\displaystyle \lim_{{x \to {end_choice}}} f(x)"
        
        # --- Part 3: Conceptual Target ---
        # Pick an interesting point that was NOT evaluated in Part 1
        concept_keys = [k for k in ["jump", "hole", "va"] if k != p_focus]
        c_focus = choice(concept_keys)
        c3_ans = points[c_focus]["x"]
        
        if c_focus == "hole":
            if base_graph == 1:
                concept_q = rf"For what value <m>c</m> do both <m>\displaystyle \lim_{{x\to c}} f(x)</m> and <m>f(c)</m> exist, but <m>\displaystyle \lim_{{x\to c}} f(x) \neq f(c)</m>?"
            else:
                concept_q = rf"For what value <m>c</m> does <m>\displaystyle \lim_{{x\to c}} f(x)</m> exist, but <m>f(c)</m> does not?"
        elif c_focus == "jump":
            concept_q = rf"For what value <m>c</m> does <m>\displaystyle \lim_{{x\to c}} f(x)</m> not exist, but <m>f(c)</m> does?"
        elif c_focus == "va":
            concept_q = rf"For what value <m>c</m> is <m>\displaystyle \lim_{{x \to c^-}} f(x) = -\infty</m> and <m>\displaystyle \lim_{{x \to c^+}} f(x) = \infty</m>?"

        # Helper to format DNE and infinities safely for LaTeX inside the <outtro>
        def render_ans(val):
            if val == "DNE": return r"\text{DNE}"
            if isinstance(val, str): return val
            return str(val)

        ans_a = render_ans(points[p_focus]["L"])
        ans_b = render_ans(points[p_focus]["R"])
        ans_c = render_ans(points[p_focus]["lim"])
        ans_d = render_ans(points[p_focus]["val"])
        ans2 = render_ans(ends[end_choice])
        
        # Adhering to the Zero-Text Rule: Mapping steps perfectly to the prompt sections
        outtro = (
            f"<outtro>\n"
            f"    <p><m>\\text{{(a) }} {limit_a_q} = {ans_a}</m></p>\n"
            f"    <p><m>\\text{{(b) }} {limit_b_q} = {ans_b}</m></p>\n"
            f"    <p><m>\\text{{(c) }} {limit_c_q} = {ans_c}</m></p>\n"
            f"    <p><m>\\text{{(d) }} {limit_d_q} = {ans_d}</m></p>\n"
            f"    <p><m>{lim2_q} = {ans2}</m></p>\n"
            f"    <p><m>c = {c3_ans}</m></p>\n"
            f"</outtro>"
        )

        return {
            "tikz_graph": tikz_code,
            "c1": c1,
            "limit_a_q": limit_a_q,
            "limit_b_q": limit_b_q,
            "limit_c_q": limit_c_q,
            "limit_d_q": limit_d_q,
            "lim2_q": lim2_q,
            "concept_q": concept_q,
            "outtro": outtro
        }