% This is the one button testing suite for fixing up ibt with.
% 
% set up the right directory
% run the algo on the songs to get the results
% write the results out to the right place
% potentially correct these
% run test_beats with the right arguments (I should make it a function)
% 
% run extract.py
% run plots to get some visual feedback
% 

% set up the filename, there are going to be a bunch of different things to test.
num = 1;
while true
    if not(exist('../music/open/_ibt', 'dir') == 7)
        outdir = strcat('../music/open/_ibt');
        one_button_algo_name = 'ibt';
        break

    elseif exist(strcat('../music/open/_ibt_', int2str(num)), 'dir') == 7
        num = num + 1;

    else
        outdir = strcat('../music/open/_ibt_', int2str(num));
        one_button_algo_name = strcat('ibt_', int2str(num));
        break
    end
end
outdir
mkdir(outdir);

% run script that fills this directory
% system('')

one_button_algo_name = 'ibt';

test_beats

system('./extract.py all sum_of_tempos:mean');

plots


