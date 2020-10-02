#!/usr/bin/env python3

# move_comments.py

from pathlib import Path
# from dataclasses import dataclass, field, Field


p = Path('.')


script_path = Path(__file__).resolve().parents
here = Path().cwd()

print(f"script location: {str(script_path[0]):<55.55}")
print(f"current path:    {str(here):<55.55}")
print(p)


# with Path()
