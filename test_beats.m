% The reference beats
ref_dir = '../music/open/_ground_truth/';
ref_files = dir( strcat(ref_dir,'*.txt') );

pretty_algo_name = 'ground_truth';
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


% Tn_ = normal tempo
% Td = double tempo
% Th = half tempo

% Bon = on beat
% Boff = off beat
% Bodd = odd beat
% Beven = even beat

% cont = longest continuously correct
% tot = total proportion correct

% the first line is for a high level analysis
% the others are for looking more in depth
    X = struct('mainscore', mainscore, 'backupscores', backupscores, 'cmlC', cmlC, 'cmlT', cmlT, 'amlC', amlC, 'amlT', amlT,...
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
    S = json.dump(X); % S is simply a string, so I can play around with it...
    S = strcat( '"', file(1).name(1:8), '":', S, ',');
    S_last = strcat(S_last, S );

    % need to put the json crap in here so I can print it out all nice

    % fileID = fopen(outfile, 'a+');
    % fprintf(fileID, 'testing: %s\nprelim_results: %f\nbackup scores: %f %f %f\n\n', test_file, mainscore, backupscores(1), backupscores(2), backupscores(3) );
    % fclose(fileID);


end

out = S_last;

% remove the last comma
out = out(1:end-1);

% close the score object from each guy
% so I can do analytics
out = strcat(out, '}}');

% turn the string into a matlab object
X = json.load(out);
disp(X);

% Now get stats on all of the songs put together.

teststruct = eval(['X.' pretty_algo_name]);
fields = fieldnames(teststruct);

% get all the information out of the songs.
scores = [];
for fn=fields'
    scores = [scores teststruct.(fn{1}).mainscore];
end

% analytics have been collected, put it into a json

% remove the last brace to restart
out = out(1:end-1);

% add the start of the next object
out = strcat(out, ',"', pretty_algo_name, '_data":{');

% put info into the object

out = strcat(out, strcat( '"mean_score":', num2str(mean(scores)), ',' ));
out = strcat(out, strcat( '"median_score":', num2str(median(scores)), ',' ));
out = strcat(out, strcat( '"max_score":', num2str(max(scores)), ',' ));
out = strcat(out, strcat( '"min_score":', num2str(min(scores)), ',' ));

% remove the last comma
out = out(1:end-1);

% finish up this object
out = strcat(out,'}');

% finish up...
out = strcat(out, '}');

json.write(out, outfile);


