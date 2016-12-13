% tests the beats of a single song

song_name = 'open_008';
algo_name = '_test';

% The reference beats
ref_dir = '../music/open/_ground_truth/';
ref_file_name = strcat(song_name,'.txt');


% The beats the algorithm measured
test_dir = strcat( '../music/open/', algo_name, '/' );
test_file_name = strcat( song_name, '.txt');



% Reading floats
formatSpec = '%f';

ref_file = strcat( ref_dir, ref_file_name );
test_file = strcat( test_dir, test_file_name );

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

