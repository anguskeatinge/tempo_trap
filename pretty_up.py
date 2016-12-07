#!/usr/bin/env python
import json
from pprint import pprint
import sys


with open("results/r2b2.json") as data_file:
    data = json.load(data_file)

for key in data:
    if key.endswith('data'):
        pprint(data[key])


