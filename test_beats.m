% The reference beats
ref_dir = 'music/open/_ground_truth/';
ref_files = dir( strcat(ref_dir,'*.txt') );

algo_name = '_r2b2';

% The beats the algorithm measured
test_dir = strcat( 'music/open/', algo_name, '/' );
test_files = dir( strcat( test_dir, '*.txt') );


% REading floats
formatSpec = '%f';

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

    [ mainscore, backupscores ] = beatEvaluator(detections',annotations');

    fileID = fopen(strcat('r2b2_test_results.txt'), 'a+');
    fprintf(fileID, 'testing: %s\nresults: %f\nbackup scores: %f %f %f\n\n', test_file, mainscore, backupscores(1), backupscores(2), backupscores(3) );
    fclose(fileID);

end
