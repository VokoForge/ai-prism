#!/usr/bin/env python3
"""scripts/validate_svg.py — CI 用的 SVG 校验脚本"""
import xml.etree.ElementTree as ET
import os
import sys

failed = 0
for f in sorted(os.listdir('assets')):
    if f.endswith('.svg'):
        try:
            ET.parse(f'assets/{f}')
            print(f'OK {f}')
        except Exception as e:
            print(f'FAIL {f}: {e}')
            failed += 1

if failed:
    sys.exit(1)
print(f'\nAll {len([f for f in os.listdir("assets") if f.endswith(".svg")])} SVGs valid')
