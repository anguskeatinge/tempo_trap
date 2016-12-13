% makes boxplots from results.

test_files = dir( strcat( 'results/*.json') );

test_files.name;


count = 1;
for fname = [test_files']
	X = json.read(strcat('results/',fname.name));

	for key = [fieldnames(X)']
		s = mat2str(key{1});
		s = s( (length(s)-4):(length(s) - 1) );

		if strcmp(s , 'data')
			key{1}
			sum_of_tempos = X.(key{1}).sum_of_tempos.array;
			beat = X.(key{1}).beat.array;
			tempo = X.(key{1}).tempo.array;
			official = X.(key{1}).official.array;
			phase = X.(key{1}).phase.array;

			main_plot_matrix(:,count) = official;
			beat_plot_matrix(:,count) = beat;
			phase_plot_matrix(:,count) = phase;
			tempo_plot_matrix(:,count) = tempo;
			sum_of_tempo_plot_matrix(:,count) = sum_of_tempos;

		else
			X.(key{1});
		end
	end

	count = count + 1;
end

main_plot_matrix

figure

boxplot(main_plot_matrix);
title ('mean of official scores');

figure

boxplot(beat_plot_matrix);
title ('beat');

figure

boxplot(phase_plot_matrix);
title ('phase');

figure

boxplot(tempo_plot_matrix);
title ('tempo');

figure

boxplot(sum_of_tempo_plot_matrix);
title ('sum of tempos (generous scores)');
