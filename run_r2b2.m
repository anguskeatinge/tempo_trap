


% goes through and annotates data for all songs in a set

data_dir = '../music/open'
data_files = dir( strcat(data_dir, '/*.wav') );

results_dir = '../music/open/_r2b3_3/';

data_files.name;

for file = data_files'

    % break the filename into it's componoents
    [pathstr, name, ext] = fileparts(file.name);

    strcat( name, ext )

    diary(strcat(results_dir, name, '.txt'));
    diary on
    r2b2( strcat( name, ext ), data_dir );
    % strcat( results_dir, name, ext )
    diary off

    % % in case the file exisits already, I don't want two songs in one file.
    % delete ( strcat( results_dir, name, '.txt' ) );
    % fileID = fopen( strcat( results_dir, name, '.txt' ), 'a+' );
    
    % % write out to file.
    % for num = b
    %     fprintf(fileID, '%f\n', num );
    % end

    % fclose(fileID);
    
end

