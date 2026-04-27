#!/usr/bin/env python3
"""Safer wrapper for `checkit generate` that validates outcome slug names.

Usage examples:
  python3 scripts/checkit_generate.py -r -o Composition_Algebra_Half_Angle
  python3 scripts/checkit_generate.py -ri -o ALL
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import xml.etree.ElementTree as ET
from difflib import get_close_matches
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
BANK_XML = REPO_ROOT / "bank.xml"


def _strip_text(value: str | None) -> str:
    return "" if value is None else value.strip()


def load_outcomes(bank_xml: Path) -> list[dict[str, str]]:
    root = ET.parse(bank_xml).getroot()
    namespace = {}
    if root.tag.startswith("{"):
        namespace["c"] = root.tag.split("}", 1)[0][1:]

    if namespace:
        outcome_nodes = root.findall("c:outcomes/c:outcome", namespace)
        def get_text(node: ET.Element, tag: str) -> str:
            return _strip_text(node.findtext(f"c:{tag}", default="", namespaces=namespace))
    else:
        outcome_nodes = root.findall("outcomes/outcome")
        def get_text(node: ET.Element, tag: str) -> str:
            return _strip_text(node.findtext(tag, default=""))

    outcomes = []
    for node in outcome_nodes:
        slug = get_text(node, "slug")
        path = get_text(node, "path")
        outcomes.append({
            "slug": slug,
            "path": path,
            "folder": Path(path).name if path else "",
        })
    return outcomes


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Validate outcome slug before running checkit generate")
    parser.add_argument("-a", "--amount", type=int, default=1000, help="Amount of exercises to generate")
    parser.add_argument("-r", "--regenerate", action="store_true", help="Force regeneration")
    parser.add_argument("-i", "--images", action="store_true", help="Generate images")
    parser.add_argument("-o", "--outcome", default="ALL", help='Outcome slug to generate. Use "ALL" for all outcomes')
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    outcomes = load_outcomes(BANK_XML)
    valid_slugs = [o["slug"] for o in outcomes if o["slug"]]

    requested = args.outcome
    if requested != "ALL" and requested.lower() not in {s.lower() for s in valid_slugs}:
        by_folder = {o["folder"].lower(): o["slug"] for o in outcomes if o["folder"] and o["slug"]}
        suggestion = by_folder.get(requested.lower())

        if suggestion is None:
            lower_to_slug = {s.lower(): s for s in valid_slugs}
            close = get_close_matches(requested.lower(), list(lower_to_slug.keys()), n=1, cutoff=0.6)
            if close:
                suggestion = lower_to_slug[close[0]]

        lines = [
            f"Error: '{requested}' is not a valid outcome slug.",
            "Use the <slug> value from bank.xml (not the folder path).",
        ]
        if suggestion:
            lines.append(f"Did you mean: -o {suggestion}")
        else:
            lines.append("Available slugs:")
            lines.append(", ".join(valid_slugs))
        print("\n".join(lines), file=sys.stderr)
        return 2

    cmd = ["sage", "--python", "-m", "checkit", "generate", "-a", str(args.amount), "-o", args.outcome]
    if args.regenerate:
        cmd.append("-r")
    if args.images:
        cmd.append("-i")

    completed = subprocess.run(cmd, cwd=REPO_ROOT)
    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
