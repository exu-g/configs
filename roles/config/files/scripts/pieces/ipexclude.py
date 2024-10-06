#!/usr/bin/env python3

from ipaddress import ip_network
import argparse

parser = argparse.ArgumentParser(description="")

parser.add_argument(
    "-e",
    "--exclude",
    required=False,
    type=str,
    action="append",
    help="IP range that should be excluded from 0.0.0.0/0",
)

args = parser.parse_args()

start: str = "0.0.0.0/0"
exclude: list[str] = args.exclude

result = [ip_network(start)]
for i in exclude:
    n = ip_network(i)
    new = []
    for k in result:
        if k.overlaps(n):
            new.extend(k.address_exclude(n))
        else:
            new.append(k)
    result = new

print(", ".join(str(i) for i in sorted(result)) + ", ::0/0")
