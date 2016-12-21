% tests the beats of a dataset


% The reference beats
ref_dir = '../music/open/_ground_truth/';
ref_files = dir( strcat(ref_dir,'*.txt') );

if one_button_algo_name

    pretty_algo_name = one_button_algo_name;
    algo_name = strcat('_', pretty_algo_name);
    test_dir = strcat( '../music/open/', algo_name, '/' );

    test_files = dir( strcat( test_dir, '*.txt') );

    clear one_button_algo_name;

else


    pretty_algo_name = 'r2b2_master_b';
    algo_name = strcat('_', pretty_algo_name);
    % The beats the algorithm measured
    test_dir = strcat( '../music/open/', algo_name, '/' );
    test_files = dir( strcat( test_dir, '*.txt') );

end

return
% Reading floats
formatSpec = '%f';

% set up the filename, there are going to be a bunch of different things to test.
num = 0;
while true
    if not(exist(strcat('ibt_results/', pretty_algo_name, '.json'), 'file') == 2)
        outfile = strcat('ibt_results/', pretty_algo_name, '.json');
        break

    elseif exist(strcat('ibt_results/', pretty_algo_name, '_', int2str(num), '.json'), 'file') == 2
        num = num + 1;

    else
        outfile = strcat('ibt_results/', pretty_algo_name, '_', int2str(num), '.json');
        break
    end
end


% add the opening brace and first object
S_last = strcat('{"', pretty_algo_name, '":{');

median_correct_offsets = [];
median_close_offsets = [];
i = 1;
correct_offsets_plot = [];
correct_offsets_grp = [];

close_offsets_plot = [];
close_offsets_grp = [];

correct_offset_lengths = [];
close_offset_lengths = [];


for file = [ ref_files'; test_files' ]
    % I should make sure that I'm comparing the right files here.
    ref_file = strcat( ref_dir, file(1).name );
    test_file = strcat( test_dir, file(2).name );

    fileID = fopen(ref_file,'r');
    annotations = fscanf(fileID,formatSpec);
    fclose(fileID);

    fileID = fopen(test_file,'r');
    detections = fscanf(fileID,formatSpec);
    fclose(fileID);

    % detections
    % detections = detections(1:2:end)
    % detections = detections(2:2:end)

    % Need to retrieve a whole bunch more info from here, how?
    [ beat_cmlCVec, beat_cmlTVec, phase_cmlCVec, phase_cmlTVec, tempo_cmlCVec, tempo_cmlTVec, correct_offsets, close_offsets, all_offsets] = ...
    beatEvaluator(detections',annotations');

    median_correct_offsets = [median_correct_offsets median(correct_offsets)];
    median_close_offsets = [median_close_offsets median(close_offsets)];
    
    % offsets
    % correct_offsets_plot_matrix
    correct_offsets_plot = [ correct_offsets_plot, correct_offsets ];
    correct_offsets_grp = [ correct_offsets_grp, (i)*ones( 1, length(correct_offsets) ) ];
    
    close_offsets_plot = [ close_offsets_plot, close_offsets ];
    close_offsets_grp = [ close_offsets_grp, (i)*ones( 1, length(close_offsets) ) ];

    i = i + 1;
    


    % assign the accuracy scores
    % longest continuous
    cmlC = beat_cmlCVec(1);
    % total proportion
    cmlT = beat_cmlTVec(1);
    % There are a number of alternatives, we choose the max of those.
    amlC = max(beat_cmlCVec);
    amlT = max(beat_cmlTVec);


    % use amlT as the overall score
    mainscore = amlT;
    backupscores = [amlC, cmlT, cmlC]; % in case of an amlT tie, we can use these as tie-breakers in this order.

    % raw data
    X1 = struct('mainscore', mainscore, 'backupscores', backupscores, 'cmlC', cmlC, 'cmlT', cmlT, 'amlC', amlC, 'amlT', amlT,...
        ...
        ...% for captured 'beats'
        'beat_Tn_Bon_cont', beat_cmlCVec(1), 'beat_Tn_Bon_tot', beat_cmlTVec(1),...
        'beat_Tn_Boff_cont', beat_cmlCVec(2), 'beat_Tn_Boff_tot', beat_cmlTVec(2),...
        ...
        'beat_Td_cont', beat_cmlCVec(3), 'beat_Td_tot', beat_cmlTVec(3),...
        ...
        'beat_Th_Bodd_cont', beat_cmlCVec(4), 'beat_Th_Bodd_tot', beat_cmlTVec(4),...
        'beat_Th_Beven_cont', beat_cmlCVec(5), 'beat_Th_Beven_tot', beat_cmlTVec(5),...
        ...
        ...%for captured 'phase'
        'phase_Tn_Bon_cont', phase_cmlCVec(1), 'phase_Tn_Bon_tot', phase_cmlTVec(1),...
        'phase_Tn_Boff_cont', phase_cmlCVec(2), 'phase_Tn_Boff_tot', phase_cmlTVec(2),...
        ...
        'phase_Td_cont', phase_cmlCVec(3), 'phase_Td_tot', phase_cmlTVec(3),...
        ...
        'phase_Th_Bodd_cont', phase_cmlCVec(4), 'phase_Th_Bodd_tot', phase_cmlTVec(4),...
        'phase_Th_Beven_cont', phase_cmlCVec(5), 'phase_Th_Beven_tot', phase_cmlTVec(5),...
        ...
        ...% for captured 'tempo'
        'tempo_Tn_Bon_cont', tempo_cmlCVec(1), 'tempo_Tn_Bon_tot', tempo_cmlTVec(1),...
        'tempo_Tn_Boff_cont', tempo_cmlCVec(2), 'tempo_Tn_Boff_tot', tempo_cmlTVec(2),...
        ...
        'tempo_Td_cont', tempo_cmlCVec(3), 'tempo_Td_tot', tempo_cmlTVec(3),...
        ...
        'tempo_Th_Bodd_cont', tempo_cmlCVec(4), 'tempo_Th_Bodd_tot', tempo_cmlTVec(4),...
        'tempo_Th_Beven_cont', tempo_cmlCVec(5), 'tempo_Th_Beven_tot', tempo_cmlTVec(5),...
        ...
        'correct_offsets', correct_offsets,...
        'close_offsets', close_offsets...
    );
    
    [tempo_score, tempo_choice] = max( [tempo_cmlTVec(1), tempo_cmlTVec(2), tempo_cmlTVec(3), tempo_cmlTVec(4), tempo_cmlTVec(5)] );

    [beat_score, beat_choice] = max( [beat_cmlTVec(1), beat_cmlTVec(2), beat_cmlTVec(3), beat_cmlTVec(4), beat_cmlTVec(5)] );

    [phase_score, phase_choice] = max( [phase_cmlTVec(1), phase_cmlTVec(2), phase_cmlTVec(3), phase_cmlTVec(4), phase_cmlTVec(5)] );


    % if phase_Td_tot*4 < ( max(phase_Tn_Boff_tot, phase_Tn_Bon_tot) - some_fractional_margin )
    %     only_just_accurate = true;
    % end


    % sum tempo tot's, see if they hit 1 -> good news
    sum_of_tempo_scores = sum( [tempo_cmlTVec(3), max(tempo_cmlTVec(1),tempo_cmlTVec(2)), max(tempo_cmlTVec(4),tempo_cmlTVec(5))] );

    correct_offset_lengths = [ correct_offset_lengths length(correct_offsets)];
    close_offset_lengths = [ close_offset_lengths length(close_offsets)];

    X2 = struct( 'beat_choice', [beat_choice, beat_score], 'phase_choice', [phase_choice, phase_score],...
        'tempo_choice', [tempo_choice, tempo_score],...
        'sum_of_tempo_scores', sum_of_tempo_scores,...
        'correct_offsets_median', median(correct_offsets),...
        'correct_offsets_count', length(correct_offsets),...
        'close_offsets_median', median(close_offsets),...
        'close_offsets_count', length(close_offsets),...
        'close_correct_diff', length(close_offsets) - length(correct_offsets)...
    );

    X = struct('raw', X1, 'analytics', X2);

    % push all the info for this song out.
    S = json.dump(X); % S is simply a string, so I can play around with it...
    S = strcat( '"', file(1).name(1:8), '":', S, ',');
    S_last = strcat(S_last, S );

end

figure(figHandle1);
boxplot(correct_offsets_plot, correct_offsets_grp);
title('beat offsets for correct annotations');
ylabel('positive -> lagging detection (seconds)');
xlabel('song number');
grid on;

figure(figHandle2);
boxplot(close_offsets_plot, close_offsets_grp);
title('beat offsets for close annotations');
ylabel('positive -> lagging detection (seconds)');
xlabel('song number');
grid on;

% plotting the difference between the things that got in and the things that nearly got in.
% figure
% hold on
% stem(close_offset_lengths)
% stem(correct_offset_lengths)
% hold off

%  finish up and prepare for next stage.
out = S_last;
out = out(1:end-1);
out = strcat(out, '}}');
X = json.load(out);
% disp(X);

% Now get stats on all of the songs put together.

data_struct = eval(['X.' pretty_algo_name]);
fields = fieldnames(data_struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  This is where I anned to do my analysis  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get all the information out of the songs.

% collect: which type won? (could there possibly be different for tempo and phase?)

main_scores = [];

beat_scores = [];
phase_scores = [];
tempo_scores = [];

beat_choices = [];

really_poor_performers = [];
scores_for_sum_of_tempo_scores = [];

for fn=fields'
    main_scores = [main_scores data_struct.(fn{1}).raw.mainscore];

    beat_scores = [beat_scores data_struct.(fn{1}).analytics.beat_choice(2)];
    phase_scores = [phase_scores data_struct.(fn{1}).analytics.phase_choice(2)];
    tempo_scores = [tempo_scores data_struct.(fn{1}).analytics.tempo_choice(2)];
    
    scores_for_sum_of_tempo_scores = [ scores_for_sum_of_tempo_scores data_struct.(fn{1}).analytics.sum_of_tempo_scores ];

    beat_choices = [beat_choices data_struct.(fn{1}).analytics.beat_choice(1)];

    if data_struct.(fn{1}).analytics.sum_of_tempo_scores < 0.8
        temp_val = data_struct.(fn{1}).analytics.sum_of_tempo_scores;
        really_poor_performers = [ really_poor_performers, struct('name',fn{1}, 'val', temp_val) ];
    end

end

clear plot_matrix;

% plot the data
% figure(figHandle2);
i = 1;
plot_matrix(:,i) = main_scores;
i = i + 1;
plot_matrix(:,i) = beat_scores;
i = i + 1;
plot_matrix(:,i) = phase_scores;
i = i + 1;
plot_matrix(:,i) = tempo_scores;
i = i + 1;
plot_matrix(:,i) = scores_for_sum_of_tempo_scores;
% boxplot(plot_matrix);

% really_poor_performers
% main_scores
% mean(main_scores)
% mean(median_correct_offsets)
% median_correct_offsets
% really_poor_performers__new = [];
% for val = really_poor_performers
%     really_poor_performers__new = {really_poor_performers, }
% end

% mat2str(really_poor_performers)

normal_time_on_beat_count = sum(beat_choices(:) == 1);
normal_time_off_beat_count = sum(beat_choices(:) == 2);
double_time_count = sum(beat_choices(:) == 3);
half_time_odd_beat_count = sum(beat_choices(:) == 4);
half_time_even_beat_count = sum(beat_choices(:) == 5);

switch mode(beat_choices)
    case 1
        most_popular_beat_choice = 'normal_time_on_beat';
    case 2
        most_popular_beat_choice = 'normal_time_off_beat';
    case 3
        most_popular_beat_choice = 'double_time';
    case 4
        most_popular_beat_choice = 'half_time_odd_beat';
    case 5
        most_popular_beat_choice = 'half_time_even_beat';
    otherwise
        return
end
most_popular_beat_choice_count = sum(beat_choices(:) == mode(beat_choices));


% analytics have been collected, put it into a json

% remove the last brace to restart
% and add the start of the next object
out = out(1:end-1);
out = strcat(out, ',"', pretty_algo_name, '_data":{');


X = struct('mean', mean(main_scores),...
    'median', median(main_scores),...
    'array',  main_scores...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'official', '":', S, ',');
out = strcat(out, S );

X = struct('mean', mean(beat_scores),...
    'median', median(beat_scores),...
    'array',  beat_scores...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'beat', '":', S, ',');
out = strcat(out, S );

X = struct('mean', mean(phase_scores),...
    'median', median(phase_scores),...
    'array',  phase_scores...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'phase', '":', S, ',');
out = strcat(out, S );

X = struct('mean', mean(tempo_scores),...
    'median', median(tempo_scores),...
    'array',  tempo_scores...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'tempo', '":', S, ',');
out = strcat(out, S );

X = struct('mean', mean(scores_for_sum_of_tempo_scores),...
    'median', median(scores_for_sum_of_tempo_scores),...
    'array',  scores_for_sum_of_tempo_scores,...
    'num_of_poor_performers', length(really_poor_performers),...
    'really_poor_performers', {[really_poor_performers]}...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'sum_of_tempos', '":', S, ',');
out = strcat(out, S );

% have something that converts an index to a string
X = struct('most_popular', struct( most_popular_beat_choice, most_popular_beat_choice_count ),...
    'normal_time_on_beat', normal_time_on_beat_count,...
    'normal_time_off_beat', normal_time_off_beat_count,...
    'double_time', double_time_count,...
    'half_time_odd_beat', half_time_odd_beat_count,...
    'half_time_even_beat', half_time_even_beat_count...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'beat_choices', '":', S, ',');
out = strcat(out, S );


X = struct('correct_mean_of_medians', mean(median_correct_offsets),...
    'correct_median_array', median_correct_offsets,...
    'close_mean_of_medians', mean(median_close_offsets),...
    'close_median_array', median_close_offsets...
);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'offsets', '":', S, ',');
out = strcat(out, S );


% remove the last comma
% finish up this object
% finish up the lot
out = out(1:end-1);
out = strcat(out,'}');
out = strcat(out, '}');

json.write(out, outfile);

