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

clear one_button_algo_name

plot_on = false;
compare_on = true;
json_results_dir = 'prelim_results/';

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
outdir;
mkdir(outdir);

% run script that fills this directory
% system('../sausage-meat/ibt/ibt')

one_button_algo_name = 'ibt';

one_number = test_beats(one_button_algo_name, json_results_dir, plot_on)
strcat(['./extract.py ', one_button_algo_name, ' official:mean ', json_results_dir])

% here I am writing out all the different ibt results
if compare_on
	num = 1;

	while true
	    if not(exist(strcat([json_results_dir, 'ibt.json']), 'file') == 2)
	        fname = strcat('../music/open/_ibt');
	        one_button_algo_name = 'ibt';
	        % strcat here
	        system( strcat(['./extract.py ', one_button_algo_name, ' official:mean ', json_results_dir]) );
	        continue

	    elseif exist(strcat([json_results_dir, 'ibt_', int2str(num), '.json']), 'file') == 2
	        one_button_algo_name = strcat('ibt_', int2str(num));
	        system( strcat(['./extract.py ', one_button_algo_name, ' official:mean ', json_results_dir]) );
	        num = num + 1;
	        continue

	    else
	        break

	    end
	end
end

if plot_on
	plots
end



