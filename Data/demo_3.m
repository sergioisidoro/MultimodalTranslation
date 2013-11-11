% This demo plots some statistics about the questionnaire answers.

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

%%

clear;

addpath('./libraries/MOCAP_manchester');
addpath('./libraries/MOCAP_manchester/NDLUTIL0p161');
addpath('./helper_functions');

load('motion_data_and_normalized_features.mat');

%% Reduce dimensionality and plot

[coeff, score, latent] = princomp(motion_features');

%% Read the annotations

annotations = f_read_answers();

%% This will plot the answers per language

finnish = 0;
swedish = 0;
english = 0;

is_finnish = zeros(1, length(annotations));

for i = 1 : length(annotations)
    if (strcmpi(annotations(i).answers_in_language, 'suomi'))
        finnish = finnish + 1;
        is_finnish(i) = 1;
    end
    if (strcmpi(annotations(i).answers_in_language, 'svenska') || strcmpi(annotations(i).answers_in_language, 'ruotsi'))
        swedish = swedish + 1;
    end
    if (strcmpi(annotations(i).answers_in_language, 'english'))
        english = english + 1;
    end
end

other = length(annotations) - finnish - swedish - english;

figure(1);
bar([(finnish+swedish+english+other) finnish swedish english other]);
set(gca,'YTick', 0:2:30);
ylabel('Number persons of answering');
set(gca,'XTickLabel',{'all' 'Finnish' 'Swedish' 'English' 'other'})
title('Answers per language');

%% Cumulative answers for the videos

% This will plot the cumulative answers per videos for the Finnish
% language. From the plot you can see that most people answered only the
% set A (24 videos), while less than half answered also the set B
% (totalling 64 videos) and only a few aswered all the 124 videos.

figure(2);
num_of_ans = cellfun(@length, {annotations(logical(is_finnish)).videos});
x = 1:1:124;
x_inv = 124:-1:1;
counts = histc(num_of_ans, x);
counts = counts(x_inv);
cum_counts = cumsum(counts);
bar(x,cum_counts,'BarWidth',1);
xlabel('Number of annotated videos (in Finnish)');
ylabel('Number persons of answering');
set(gca,'XLim',[0 124])
set(gca,'XTick',[0 61 101 124])
set(gca,'XTickLabel', {'124' '64' '24' '0'});
title('Cumulative amount of persons answering the videos');


%% Process words: get data from Finnish answers

for i = 1 : length(data)
    data(i).adjective_1 = [];
    data(i).adjective_2 = [];
    data(i).adjective_3 = [];
    data(i).verb = [];
end

for i_anno = 1 : length(annotations)
    for i_data = 1 : length(data)
        for i_video = 1 : length(annotations(i_anno).videos)
            name = data(i_data).filename(regexp(data(i_data).filename, '/\S+.bvh') + 1 : length(data(i_data).filename) - 4);
            if (strcmp(annotations(i_anno).videos(i_video), name) && strcmpi(annotations(i_anno).answers_in_language, 'suomi'))
                verb = lower(annotations(i_anno).verbs(i_video));
                adjective_1 = lower(annotations(i_anno).adjectives_1(i_video));
                adjective_2 = lower(annotations(i_anno).adjectives_2(i_video));
                adjective_3 = lower(annotations(i_anno).adjectives_3(i_video));
                data(i_data).verb = [data(i_data).verb verb];
                data(i_data).adjective_1 = [data(i_data).adjective_1 adjective_1];
                data(i_data).adjective_2 = [data(i_data).adjective_2 adjective_2];
                data(i_data).adjective_3 = [data(i_data).adjective_3 adjective_3];  
            end
        end
    end
end

%% Combine different word forms

for i1 = 1 : length(data)
    for i2 = 1 : length(data(i1).verb)
        data(i1).verb(i2) = strrep({f_clean_up_finnish_verbs(data(i1).verb{i2})}, '_', '');
        data(i1).adjective_1(i2) = strrep({f_clean_up_finnish_adjectives(data(i1).adjective_1{i2})}, '_', '');
        data(i1).adjective_2(i2) = strrep({f_clean_up_finnish_adjectives(data(i1).adjective_2{i2})}, '_', '');
        data(i1).adjective_3(i2) = strrep({f_clean_up_finnish_adjectives(data(i1).adjective_3{i2})}, '_', '');
    end
end

%% Process words: calculate most used verbs

used_verbs = [data(:).verb];
unique_verbs = unique(used_verbs);
verb_counts = zeros(size(unique_verbs));
for i1 = 1 : length(verb_counts)
    verb_counts(i1) = sum(strcmp(used_verbs(:), unique_verbs(i1)));
end
verb_order = sortrows([1:length(unique_verbs); verb_counts]', -2);

for i1 = 1 : length(unique_verbs)
    verb_table{i1, 1} = unique_verbs(verb_order(i1, 1)); % verb
    verb_table{i1, 2} = verb_order(i1, 2); % number of total usage
end

sorted_unique_verbs = [verb_table{:, 1}];

figure(6);
barh(cell2mat(verb_table(1:38,2)));
xlabel('number of apperances');
set(gca,'YTick', 1:38);
set(gca,'YTickLabel', {sorted_unique_verbs{1:38}});
title('Most used Finnish verbs');


%% Process words: calculate most used adjectives

used_adjectives = [data(:).adjective_1 data(:).adjective_2 data(:).adjective_3];
unique_adjectives = unique(used_adjectives)';
adjective_counts = zeros(size(unique_adjectives));
for i1 = 1 : length(adjective_counts)
    adjective_counts(i1) = sum(strcmp(used_adjectives(:), unique_adjectives(i1)));
end
adjective_order = sortrows([1:length(unique_adjectives); adjective_counts']', -2);

for i1 = 1 : length(unique_adjectives)
    adjective_table{i1, 1} = unique_adjectives(adjective_order(i1, 1)); % adjective
    adjective_table{i1, 2} = adjective_order(i1, 2); % number of total usage
end

sorted_unique_adjectives = [adjective_table{:, 1}];
sorted_unique_adjectives{1} = '-';

total_adjectives_given = sum([adjective_table{2:end, 2}]);

figure(7);
barh(cell2mat(adjective_table(2:38,2)));
xlabel('number of apperances');
set(gca,'YTick', 1:37);
set(gca,'YTickLabel', {sorted_unique_adjectives{2:38}});
title('Most used Finnish adjectives/adverbs');
