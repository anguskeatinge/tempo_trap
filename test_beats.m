% The reference beats
ref_dir = '../music/open/_ground_truth/';
ref_files = dir( strcat(ref_dir,'*.txt') );

pretty_algo_name = 'r2b2';
algo_name = strcat('_', pretty_algo_name);

% The beats the algorithm measured
test_dir = strcat( '../music/open/', algo_name, '/' );
test_files = dir( strcat( test_dir, '*.txt') );



% Reading floats
formatSpec = '%f';

% set up the filename, there are going to be a bunch of different things to test.
num = 0;
while true
    if not(exist(strcat('prelim_results/', pretty_algo_name, '.json'), 'file') == 2)
        outfile = strcat('prelim_results/', pretty_algo_name, '.json');
        break

    elseif exist(strcat('prelim_results/', pretty_algo_name, '_', int2str(num), '.json'), 'file') == 2
        num = num + 1;

    else
        outfile = strcat('prelim_results/', pretty_algo_name, '_', int2str(num), '.json');
        break
    end
end


% add the opening brace and first object
S_last = strcat('{"', pretty_algo_name, '":{');

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

    % Need to retrieve a whole bunch more info from here, how?
    [ beat_cmlCVec, beat_cmlTVec, phase_cmlCVec, phase_cmlTVec, tempo_cmlCVec, tempo_cmlTVec ] = ...
    beatEvaluator(detections',annotations');


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
        'tempo_Th_Beven_cont', tempo_cmlCVec(5), 'tempo_Th_Beven_tot', tempo_cmlTVec(5)...
        ...
    );
    
    [tempo_score, tempo_choice] = max( [tempo_cmlTVec(1), tempo_cmlTVec(2), tempo_cmlTVec(3), tempo_cmlTVec(4), tempo_cmlTVec(5)] );

    [beat_score, beat_choice] = max( [beat_cmlTVec(1), beat_cmlTVec(2), beat_cmlTVec(3), beat_cmlTVec(4), beat_cmlTVec(5)] );

    [phase_score, phase_choice] = max( [phase_cmlTVec(1), phase_cmlTVec(2), phase_cmlTVec(3), phase_cmlTVec(4), phase_cmlTVec(5)] );

    % % analytics on raw data
    % X2 = struct( strcat('beat_choice_', num2str(beat_choice)), beat_score, strcat('phase_choice_', num2str(phase_choice)), phase_score,...
    %     strcat('tempo_choice_', num2str(tempo_choice)), tempo_score...
    % );

    X2 = struct( 'beat_choice', [beat_choice, beat_score], 'phase_choice', [phase_choice, phase_score],...
        'tempo_choice', [tempo_choice, tempo_score]...
    );

    X = struct('raw', X1, 'analytics', X2);

    % push all the info for this song out.
    S = json.dump(X); % S is simply a string, so I can play around with it...
    S = strcat( '"', file(1).name(1:8), '":', S, ',');
    S_last = strcat(S_last, S );


    % if phase_Td_tot*4 < ( max(phase_Tn_Boff_tot, phase_Tn_Bon_tot) - some_fractional_margin )
    %     only_just_accurate = true;
    % end


    % sum tempo tot's, see if they hit 1 -> good news


end

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

for fn=fields'
    main_scores = [main_scores data_struct.(fn{1}).raw.mainscore];

    beat_scores = [beat_scores data_struct.(fn{1}).analytics.beat_choice(2)];
    phase_scores = [phase_scores data_struct.(fn{1}).analytics.phase_choice(2)];
    tempo_scores = [tempo_scores data_struct.(fn{1}).analytics.tempo_choice(2)];
end




% analytics have been collected, put it into a json

% remove the last brace to restart
% and add the start of the next object
out = out(1:end-1);
out = strcat(out, ',"', pretty_algo_name, '_data":{');



% put info into the object
out = strcat(out, strcat( '"mean_score":', num2str(mean(main_scores)), ',' ));
out = strcat(out, strcat( '"median_score":', num2str(median(main_scores)), ',' ));
out = strcat(out, strcat( '"max_score":', num2str(max(main_scores)), ',' ));
out = strcat(out, strcat( '"min_score":', num2str(min(main_scores)), ',' ));

out = strcat(out, strcat( '"beat_mean_score":', num2str(mean(beat_scores)), ',' ));
out = strcat(out, strcat( '"beat_median_score":', num2str(median(beat_scores)), ',' ));
out = strcat(out, strcat( '"beat_max_score":', num2str(max(beat_scores)), ',' ));
out = strcat(out, strcat( '"beat_min_score":', num2str(min(beat_scores)), ',' ));

out = strcat(out, strcat( '"phase_mean_score":', num2str(mean(phase_scores)), ',' ));
out = strcat(out, strcat( '"phase_median_score":', num2str(median(phase_scores)), ',' ));
out = strcat(out, strcat( '"phase_max_score":', num2str(max(phase_scores)), ',' ));
out = strcat(out, strcat( '"phase_min_score":', num2str(min(phase_scores)), ',' ));

out = strcat(out, strcat( '"tempo_mean_score":', num2str(mean(tempo_scores)), ',' ));
out = strcat(out, strcat( '"tempo_median_score":', num2str(median(tempo_scores)), ',' ));
out = strcat(out, strcat( '"tempo_max_score":', num2str(max(tempo_scores)), ',' ));
out = strcat(out, strcat( '"tempo_min_score":', num2str(min(tempo_scores)), ',' ));

X = struct('elements_inside', mainscore, 'this', backupscores);
S = json.dump(X); % S is simply a string, so I can play around with it...
S = strcat( '"', 'category over X', '":', S, ',');
out = strcat(out, S );

% remove the last comma
% finish up this object
% finish up the lot
out = out(1:end-1);
out = strcat(out,'}');
out = strcat(out, '}');

json.write(out, outfile);

