#!/usr/bin/env python
import json
from pprint import pprint
import sys

# algo = 'ground_truth'
# algo = 'essentia_multifeature'
# algo = 'ellis_beat2'

algo = 'r2b2'

with open("results/" + algo + ".json") as data_file:
    data = json.load(data_file)

for key in data:
    if key.endswith('data'):
        pprint(data[key])


