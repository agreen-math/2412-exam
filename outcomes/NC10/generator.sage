from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # 1. Randomize Global Rigid Transformations
        sx = random.choice([Integer(1), Integer(-1)])
        sy = random.choice([Integer(1), Integer(-1)])
        h = random.randint(-1, 1) 
        k = random.randint(-1, 1)
        
        def T(x, y):
            return (sx * x + h, sy * y + k)

        # 2. Track the Transformed Features 
        features = {
            "hole_only": {
                "x": sx * (-5) + h,
                "L_lim": sy * 1 + k,
                "R_lim": sy * 1 + k,
                "full_lim": sy * 1 + k,
                "f_val": "DNE"
            },
            "jump": {
                "x": sx * (-1) + h,
                "L_lim": sy * (2.5 if sx == 1 else -2) + k, 
                "R_lim": sy * (-2 if sx == 1 else 2.5) + k,
                "full_lim": "DNE",
                "f_val": sy * (-2) + k
            },
            "hole_point": {
                "x": sx * (3) + h,
                "L_lim": sy * 2 + k,
                "R_lim": sy * 2 + k,
                "full_lim": sy * 2 + k,
                "f_val": sy * -3 + k
            }
        }
        
        keys = ["hole_only", "jump", "hole_point"]
        random.shuffle(keys)
        q_multi = features[keys[0]]
        q_single = features[keys[1]]

        def fmt(val):
            return r"\text{DNE}" if val == "DNE" else latex(val)

        # Formatting values for limit subscripts: wrap in () if negative
        def sub_fmt(val):
            return rf"({val})" if isinstance(val, (int, Integer)) and val < 0 else latex(val)

        # 4. End Behavior Logic
        inf_dir_val = random.choice([-1, 1])
        # Improved: wrap negative infinity in parentheses
        inf_dir_str = r"(-\infty)" if inf_dir_val == -1 else r"\infty"
        
        if inf_dir_val * sx == 1:
            ans_inf = r"-\infty" if sy == 1 else r"\infty"
        else:
            ans_inf = r"-\infty"

        # 5. Build TikZ String (Entities &lt; and &gt; for XML safety)
        grid = rf"""
            \clip (-8.5,-5.5) rectangle (8.5,5.5);
            \draw[black!40] (-8,-5) grid (8,5);
            \draw[very thick, &lt;-&gt;] (-8.5,0) -- (8.5,0) node[right] {{x}};
            \draw[very thick, &lt;-&gt;] (0,-5.5) -- (0,5.5) node[above] {{y}};
        """
        
        labels = ""
        for i in range(-8, 9, 2):
            if i != 0: labels += rf"\node[below, tiny, fill=white, inner sep=1pt] at ({i},0) {{{i}}};"
        for j in range(-4, 5, 2):
            if j != 0: labels += rf"\node[left, tiny, fill=white, inner sep=1pt] at (0,{j}) {{{j}}};"

        p1 = rf"\draw[blue, ultra thick, &lt;-&gt;, domain={sx*(-8.5)+h}:{sx*(-3.25)+h}, samples=50] plot (\x, {{ {sy}*(0.5*((\x-{h})/{sx}) + 3 - 1/( ((\x-{h})/{sx}) + 3)) + {k} }});"
        p2 = rf"\draw[blue, ultra thick, -&gt;, domain={sx*(-2.85)+h}:{sx*(-1)+h}, samples=50] plot (\x, {{ {sy}*(0.5*((\x-{h})/{sx}) + 3 - 1/( ((\x-{h})/{sx}) + 3)) + {k} }});"
        m_start = T(-1, -2)
        m_end = T(3, 2)
        p3 = rf"\draw[blue, ultra thick] ({m_start[0]}, {m_start[1]}) -- ({m_end[0]}, {m_end[1]});"
        p4 = rf"\draw[blue, ultra thick, -&gt;, domain={sx*(3)+h}:{sx*(7)+h}, samples=50] plot (\x, {{ {sy}*(-(((\x-{h})/{sx})-4)**2 + 3) + {k} }});"

        h1 = T(-5, 1)
        h2 = T(-1, 2.5) 
        h3 = T(-1, -2) 
        h4 = T(3, 2)
        p_extra2 = T(3, -3)

        dots = rf"""
            \filldraw[white, draw=blue, thick] ({h1[0]}, {h1[1]}) circle (5pt);
            \filldraw[white, draw=blue, thick] ({h2[0]}, {h2[1]}) circle (5pt);
            \filldraw[blue] ({h3[0]}, {h3[1]}) circle (5pt);
            \filldraw[white, draw=blue, thick] ({h4[0]}, {h4[1]}) circle (5pt);
            \filldraw[blue] ({p_extra2[0]}, {p_extra2[1]}) circle (5pt);
        """

        graph_tikz = rf"\begin{{tikzpicture}}[scale=0.5, &gt;=triangle 45]{grid}{labels}{p1}{p2}{p3}{p4}{dots}\end{{tikzpicture}}"

        return {
            "graph_tikz": graph_tikz,
            "c_multi": q_multi["x"],
            "c_multi_sub": sub_fmt(q_multi["x"]),
            "ans_L": rf"\boxed{{ {fmt(q_multi['L_lim'])} }}",
            "ans_R": rf"\boxed{{ {fmt(q_multi['R_lim'])} }}",
            "ans_full": rf"\boxed{{ {fmt(q_multi['full_lim'])} }}",
            "ans_val": rf"\boxed{{ {fmt(q_multi['f_val'])} }}",
            "c_single": q_single["x"],
            "c_single_sub": sub_fmt(q_single["x"]),
            "ans_single": rf"\boxed{{ {fmt(q_single['full_lim'])} }}",
            "inf_dir": inf_dir_str,
            "ans_inf": rf"\boxed{{ {ans_inf} }}"
        }