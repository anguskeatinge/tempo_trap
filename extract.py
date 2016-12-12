#!/usr/bin/env python
import json
from pprint import pprint
import sys

# algo = 'ground_truth'
# algo = 'essentia_multifeature'
# algo = 'ellis_beat2'

algos = ['ground_truth', 'essentia_multifeature', 'ellis_beat2', 'btrack', 'r2b2', 'r2b2_a']

for algo in algos:

	with open("results/" + algo + ".json") as data_file:
	    data = json.load(data_file)

	print ("")
	print ("XXXXXXXXXX")
	print ("Algorithm: " + algo)
	print ("XXXXXXXXXX")
	print ("")

	for key in data:
	    if key.endswith('data'):
	        pprint(data[key])


