# Benchmark
[Current benchmark status](./scores.csv "fuck off")

### How it works
* 'test_beats.m' gets scores from 'beatEvaluator.m' for all 25 songs of the open dataset.
* It then writes out to a json file all of the results and some analysis of the results.
* the python script WILL (but not yet) take in an algo name and arguments to extract the metadata.

#### To sus out the analysis in more detail
* download 'results/' and 'extract.py'
* python extract.py <algo name> <regex pattern for scraping the results>

#### Beat trackers I still need to get results from for benchmark
1. ellis' beat_simple
2. ibt (from Jerry)
3. ALL OF OURS

#### JSON
[source code for the matlab json interface](https://github.com/kyamagu/matlab-json "you silly cunt")
To get this json shit working, download from git and follow the README, or
> \>>> addpath "path/to/json-shit"
> \>>> json.startup

#### Todo
1. Add to per song info:
    * triple the speed, four times the speed, etc.
    * where in the song it stuffs up
    * which tempo we chose (because only one will be right)
        * look out for switching between tempos
        * express these as percentages maybe.
    * which beat we chose (i.e. odd, even, on, off)

2. Analysis of data (i.e. per algo info):
	* make a generous score (and say which one it is)
    	* best tempo
    	* best phase
    	* 
    * get averages of the different measures
    * count how often certain measures hit a benchmark
    * which measure it performs the best at
    * tempo are we most likely to choose (half, double, triple) need give some stats here
    * things that are telling
    	* only one tempo at a time will be correct
    		* check if the tempo's sum to 1, (total proportion, not cont)
    	* whichever tempo is correct, we look at it's phase alignment.
    	* I'm not sure if the other phases matter (they will if we follow triplets sometimes and half beats at other times)


3. Update python script to selectively extract info from algo analysis beacause this is starting to be a bit much.

4. Classify songs:
    * easy and hard
    * average score
    * number of zero scores (or scores below 0.2)
    * triplet songs
5. Not sure if I trust phase_td_cont, what score should it get for ground truth???

##### Abbreviations
You may encounter these in the raw data
* Tn = normal tempo
* Td = double tempo
* Th = half tempo
* Bon = on beat
* Boff = off beat
* Bodd = odd beat
* Beven = even beat
* cont = longest continuously correct
* tot = total proportion correct
* cmlC = normal time, on beat, number of continuous correct beats as a proportion of all beats
* cmlT = normal time, on beat, total proportion of correct beats
* aml(C or T) = similar to above gets the max of alternative ground truth measures

