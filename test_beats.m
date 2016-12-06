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
    if exist(strcat('results/', pretty_algo_name, '_', int2str(num), '.txt'), 'file') == 2
        num = num + 1;
    else
        outfile = strcat('results/', pretty_algo_name, '_', int2str(num), '.txt');
        break
    end
end

for file = [ ref_files'; test_files' ]
    % I should make sure that I'm comparing the right files here.
    ref_file = strcat( ref_dir, file(1).name );
    test_file = strcat( test_dir, file(2).name );

    fileID = fopen(ref_file,'r');
    annotations = fscanf(fileID,formatSpec)
    fclose(fileID);

    fileID = fopen(test_file,'r');
    detections = fscanf(fileID,formatSpec)
    fclose(fileID);

    [ mainscore, backupscores ] = beatEvaluator(detections',annotations');

    % need to put the json crap in here so I can print it out all nice

    fileID = fopen(outfile, 'a+');
    fprintf(fileID, 'testing: %s\nresults: %f\nbackup scores: %f %f %f\n\n', test_file, mainscore, backupscores(1), backupscores(2), backupscores(3) );
    fclose(fileID);

end
