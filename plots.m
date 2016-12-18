% makes boxplots from results.

test_files = dir( strcat( 'results/*.json') );


clear official_plot_matrix;
clear beat_plot_matrix;
clear phase_plot_matrix;
clear tempo_plot_matrix;
clear sum_of_tempo_plot_matrix;


count = 1;
for fname = [test_files']
	X = json.read(strcat('results/',fname.name));

	for key = [fieldnames(X)']
		s = mat2str(key{1});
		s = s( (length(s)-4):(length(s) - 1) );

		if strcmp(s , 'data')

			fname.name;
			key{1};

			sum_of_tempos = X.(key{1}).sum_of_tempos.array;
			beat = X.(key{1}).beat.array;
			tempo = X.(key{1}).tempo.array;
			official = X.(key{1}).official.array;
			phase = X.(key{1}).phase.array;

			official_plot_matrix(:,count) = official;
			official_mean(count) = mean(official);

			beat_plot_matrix(:,count) = beat;
			beat_mean(count) = mean(beat);
			
			phase_plot_matrix(:,count) = phase;
			phase_mean(count) = mean(phase);
			
			tempo_plot_matrix(:,count) = tempo;
			tempo_mean(count) = mean(tempo);
			
			sum_of_tempo_plot_matrix(:,count) = sum_of_tempos;
			sum_of_tempo_mean(count) = mean(sum_of_tempos);
			
			count = count + 1;

		else
			X.(key{1});
		end
	end

	
end


official_plot_matrix
length(test_files')


figure

boxplot(official_plot_matrix);
title ('official scores');
set(gca,'xtick',[1:length(test_files')],'xticklabel',{test_files.name}, 'XTickLabelRotation',45)
grid on
hold on
scatter([1:length(official_mean)],[official_mean],'marker','o')
hold off

figure

boxplot(beat_plot_matrix);
title ('beat');
set(gca,'xtick',[1:length(test_files')],'xticklabel',{test_files.name}, 'XTickLabelRotation',45)
grid on
hold on
scatter([1:length(beat_mean)],[beat_mean],'marker','o')
hold off


figure

boxplot(phase_plot_matrix);
title ('phase');
set(gca,'xtick',[1:length(test_files')],'xticklabel',{test_files.name}, 'XTickLabelRotation',45)
grid on
hold on
scatter([1:length(phase_mean)],[phase_mean],'marker','o')
hold off


figure

boxplot(tempo_plot_matrix);
title ('tempo');
set(gca,'xtick',[1:length(test_files')],'xticklabel',{test_files.name}, 'XTickLabelRotation',45)
grid on
hold on
scatter([1:length(tempo_mean)],[tempo_mean],'marker','o')
hold off


figure

boxplot(sum_of_tempo_plot_matrix);
title ('sum of tempos (generous scores)');
set(gca,'xtick',[1:length(test_files')],'xticklabel',{test_files.name}, 'XTickLabelRotation',45)
grid on
hold on
scatter([1:length(sum_of_tempo_mean)],[sum_of_tempo_mean],'marker','o')
hold off

