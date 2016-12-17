# Benchmark
[Current benchmark status](./scores.csv "fuck off")

[View benchmark plots](./plots.md "James has a fanny")

### How it works
* 'test_beats.m' gets scores from 'beatEvaluator.m' for all 25 songs of the open dataset.
* It then writes out to a json file all of the results and some analysis of the results.
* the python script WILL (but not yet) take in an algo name and arguments to extract the metadata.

#### To sus out the analysis in more detail
* download 'results/' and 'extract.py'
* python extract.py <algo name> <regex pattern for scraping the results>

#### JSON
[source code for the matlab json interface](https://github.com/kyamagu/matlab-json "you silly cunt")
To get this json shit working, download from git and follow the README, or
> \>>> init

#### Todo
1. Add to per song info:
    * triple the speed, four times the speed, etc.
    * difference between double scores and it's score.

2. Analysis of data (i.e. per algo info):
    * find the difference between sum_of_tempos and the top tempo choice
    * count how often certain measures hit a benchmark

3. Classify songs:
    * easy and hard
    * average score
    * number of zero scores (or scores below 0.2)
    * triplet songs

4. Not sure if I trust phase_td_cont, what score should it get for ground truth???

5. Streamlining:
    * single button testing suite.
    * one matlab, one shell, one python

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

