#!/usr/bin/env python
import json
from pprint import pprint
import sys
from glob import glob
import re


############## Take in the input
try:
    algo = sys.argv[1]
    variable = sys.argv[2]

    # retieve algos from here.
    
    if algo.lower() == "all":
        algos = glob('results/*.json')
    else:
        m = re.findall(r'([^,]+),', algo) + re.findall(r',?([^,]+)$', algo)
        algos = ['results/{0}.json'.format(m_elt) for m_elt in m]


    if variable.lower() == "all":
        all_vars = True
    
    else:
        all_vars = False
        _variables = re.findall(r'([^,]+),', variable) + re.findall(r',?([^,]+)$', variable)
        
        variables = []
        for variable in _variables:
            m = re.findall(r'([^:]+):', variable) + re.findall(r':?([^:]+)$', variable)
            variables.append(m)

except:
    print ("\tusage: ./test.py <algo> <variable>")
    print ("\treplace these with '*' for all variables or algos")
    print ("\tuse 'variable' like so: ")
    print ("\t\tsum_of_tempos  OR")
    print ("\t\tsum_of_tempos:mean")
    print ("\tyou can also comma separate things.")

    sys.exit()

################ Do the stuff


if all_vars:
    for algo in algos:
        # pprint (algo)

        with open(algo) as data_file:
            data = json.load(data_file)

        print ("")
        print ("XXXXXXXXXX")
        print ("Algorithm: " + algo)
        print ("XXXXXXXXXX")
        print ("")

        for key in data:
            if key.endswith('data'):
                    pprint(data[key])



elif not all_vars:
    for variable in variables:
        print("")
        if len(variable) == 1:
            print(variable[0] + ':')

        elif len(variable) == 2:
            print(variable[0] + '{' + variable[1] + '} :')

        elif len(variable) == 3:
            print(variable[0] + '{' + variable[1] + '}{' + variable[2] + '} :')

        else:
            print("yo fucked up...")

        for algo in algos:
            # pprint (algo)

            with open(algo) as data_file:
                data = json.load(data_file)

            print ("Algorithm: " + algo + ":")

            for key in data:
                if key.endswith('data'):
                    if len(variable) == 1:
                        print(data[key][variable[0]])

                    if len(variable) == 2:
                        print("\t",data[key][variable[0]][variable[1]])



