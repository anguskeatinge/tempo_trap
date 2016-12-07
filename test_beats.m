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
    if not(exist(strcat('results/', pretty_algo_name, '.json'), 'file') == 2)
        outfile = strcat('results/', pretty_algo_name, '.json');
        break

    elseif exist(strcat('results/', pretty_algo_name, '_', int2str(num), '.json'), 'file') == 2
        num = num + 1;

    else
        outfile = strcat('results/', pretty_algo_name, '_', int2str(num), '.json');
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
    [ mainscore, backupscores ] = beatEvaluator(detections',annotations');

    X = struct('mainscore', mainscore, 'backupscores', backupscores);
    S = json.dump(X); % S is simply a string, so I can play around with it...
    S = strcat( '"', file(1).name(1:8), '":', S, ',');
    S_last = strcat(S_last, S );

    % need to put the json crap in here so I can print it out all nice

    % fileID = fopen(outfile, 'a+');
    % fprintf(fileID, 'testing: %s\nresults: %f\nbackup scores: %f %f %f\n\n', test_file, mainscore, backupscores(1), backupscores(2), backupscores(3) );
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
out = strcat(out, '}')

json.write(out, outfile);


