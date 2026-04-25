from sage.all import *
import random

class Generator(BaseGenerator):
    def data(self):
        # 1. Define thematic scenarios with realistic numerical ranges
        contexts = [
            {
                "range": (200, 800),
                "text": "A surveyor wants to find the distance across a river from point <m>B</m> to point <m>A</m>. They lay out a baseline <m>BC</m> of <m>{a}</m> meters on one side of the river. They measure the angles <m>\\angle B = {B}^\\circ</m> and <m>\\angle C = {C}^\\circ</m>. Find the distance across the river from point <m>B</m> to point <m>A</m>."
            },
            {
                "range": (10, 50),
                "text": "Two fire lookout towers are located at points <m>B</m> and <m>C</m>, separated by a distance of <m>{a}</m> miles. A fire is spotted at point <m>A</m>. The rangers measure the angles <m>\\angle B = {B}^\\circ</m> and <m>\\angle C = {C}^\\circ</m>. How far is the fire from tower <m>B</m> (distance <m>AB</m>)?"
            },
            {
                "range": (50, 200),
                "text": "Two radar stations at <m>B</m> and <m>C</m> are <m>{a}</m> kilometers apart along a straight coastline. They track a ship at sea at point <m>A</m>. The angle <m>\\angle B</m> is measured as <m>{B}^\\circ</m> and <m>\\angle C</m> is <m>{C}^\\circ</m>. Find the distance from station <m>B</m> to the ship (distance <m>AB</m>)."
            },
            {
                "range": (100, 500),
                "text": "Two hikers at points <m>B</m> and <m>C</m> are <m>{a}</m> feet apart on a flat plain. They are looking at a landmark at <m>A</m>. They measure <m>\\angle B = {B}^\\circ</m> and <m>\\angle C = {C}^\\circ</m>. What is the distance from hiker <m>B</m> to the landmark (distance <m>AB</m>)?"
            }
        ]

        # 2. Randomly select a scenario
        context = random.choice(contexts)
        min_val, max_val = context["range"]

        # Generate a clean integer baseline distance
        a = random.randint(min_val, max_val)

        # 3. Generate angles to 1 decimal place, ensuring they form a valid triangle
        B = round(random.uniform(20.0, 120.0), 1)
        C = round(random.uniform(15.0, 160.0 - B), 1)

        # Calculate the missing third angle
        A = round(180.0 - B - C, 1)

        # 4. Calculate the missing side (c) using the Law of Sines
        # c / sin(C) = a / sin(A) => c = a * sin(C) / sin(A)
        c = a * sin(C * pi / 180) / sin(A * pi / 180)
        c_val = round(float(c), 1)

        # Dynamically inject the generated values into the chosen word problem
        prompt_text = context["text"].format(a=a, B=B, C=C)

        # --- Build the Step-by-Step Solution ---
        step1a = rf"\text{{We are given side }} a = {a} \text{{, and angles }} \angle B = {B}^\circ \text{{ and }} \angle C = {C}^\circ."
        step1b = r"\text{We need to find the distance } AB \text{, which corresponds to side } c."
        
        step2a = r"\text{Step 1: Find the missing angle } A."
        step2b = rf"\angle A = 180^\circ - \angle B - \angle C"
        step2c = rf"\angle A = 180^\circ - {B}^\circ - {C}^\circ = {A}^\circ"
        
        step3a = r"\text{Step 2: Set up the Law of Sines to solve for } c."
        step3b = r"\frac{c}{\sin(C)} = \frac{a}{\sin(A)}"
        step3c = rf"\frac{{c}}{{\sin({C}^\circ)}} = \frac{{{a}}}{{\sin({A}^\circ)}}"
        
        step4a = r"\text{Step 3: Isolate } c \text{ and evaluate.}"
        step4b = rf"c = \frac{{{a}\sin({C}^\circ)}}{{\sin({A}^\circ)}}"
        step4c = rf"c \approx {c_val}"

        outtro_lines = [
            f"    <p><m>{step1a}</m></p>",
            f"    <p><m>{step1b}</m></p>",
            f"    <p><m>{step2a}</m></p>",
            f"    <p><m>{step2b}</m></p>",
            f"    <p><m>{step2c}</m></p>",
            f"    <p><m>{step3a}</m></p>",
            f"    <p><m>{step3b}</m></p>",
            f"    <p><m>{step3c}</m></p>",
            f"    <p><m>{step4a}</m></p>",
            f"    <p><m>{step4b}</m></p>",
            f"    <p><m>{step4c}</m></p>"
        ]

        solution_steps = "\n".join(outtro_lines)

        return {
            "prompt_text": f"<p>{prompt_text}</p>",
            "solution_steps": solution_steps
        }