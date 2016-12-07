#### How it works
'test_beats.m' gets scores from 'beatEvaluator.m' for all 25 songs of the open dataset.
It then writes out to a json file all of the results and some analysis of the results.

we run the python script to pretty print the high level results.

#### Todo

	- simple one number benchmark for each algo into a table or some nicely presented form

	- detailed breakdown of performance

Beat trackers I still need to get results from for benchmark:
	- ellis' beat_simple
	- ibt (from Jerry)
	- BTrack (from Jerry or github)

#### JSON
https://github.com/kyamagu/matlab-json
Make sure you "addpath" and json.startup to get the json shit working
