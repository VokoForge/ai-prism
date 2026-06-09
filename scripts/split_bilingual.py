#!/usr/bin/env python3
"""Split bilingual day-NN-*.md into .en.md and .zh.md.

Strategy: find the SECOND `# Day NN` heading and split there.
Day-NN posts all have this 2-heading pattern: total-title + chinese-title.
"""
import re
from pathlib import Path

POSTS = Path("posts")

for src in sorted(POSTS.glob("day-*.md")):
    text = src.read_text()
    lines = text.split("\n")

    # find all "# Day NN" headings
    h1_indices = [i for i, ln in enumerate(lines)
                  if re.match(r"^# Day \d+", ln)]
    if len(h1_indices) < 2:
        print(f"SKIP {src.name}: only {len(h1_indices)} H1 found")
        continue

    split_idx = h1_indices[1]
    en_text = "\n".join(lines[:split_idx]).rstrip() + "\n"
    zh_text = "\n".join(lines[split_idx:]).rstrip() + "\n"

    stem = src.stem
    (POSTS / f"{stem}.en.md").write_text(en_text)
    (POSTS / f"{stem}.zh.md").write_text(zh_text)
    src.unlink()
    print(f"OK {src.name} -> {stem}.en.md ({len(en_text.splitlines())}L) + {stem}.zh.md ({len(zh_text.splitlines())}L)")
