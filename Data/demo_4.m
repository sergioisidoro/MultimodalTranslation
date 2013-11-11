% This demo is an interactive visualization of the motion data
% with a stick figure animation and the demo also shows the raw
% questionnaire data.

% Some of the code used in building the user interface is a bit messy.

% User instructions:
% Run the whole file in Matlab.
% Then you can click on any of the points representing the videos in Figure 3.
% This will open two new figures. In Figure 100 the motion will be played
% once. In Figure 101 four columns will be shown first shows the verbs,
% and next three show the adjectives. Each row corresponds to one
% annotation of the video.

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
    % TODO: number of person using the word
    % TODO: number of motions where the word appears
end

sorted_unique_adjectives = [adjective_table{:, 1}];
sorted_unique_adjectives{1} = '-';

%% Process words: find most used verbs per motion

for i1 = 1 : 124
    
    % verbs
    
    [verbs, ind1, ind2] = unique(data(i1).verb);
    data(i1).most_common_verb = verbs(mode(ind2));
    
    data(i1).verb_percentages = [];
    data(i1).verb_percentage_ind = [];
    uni_ind2 = unique(ind2);
    for i2 = 1 : length(uni_ind2)
        data(i1).verb_percentages = [data(i1).verb_percentages; sum(ind2(:) == uni_ind2(i2))];
        data(i1).verb_percentage_ind = [data(i1).verb_percentage_ind; find(strcmp(sorted_unique_verbs, verbs(uni_ind2(i2))), 1)];
    end
    data(i1).verb_percentages = data(i1).verb_percentages / length(ind2);
    data(i1).verb_percentages = cumsum(data(i1).verb_percentages);
    
end

%% Process words: find most used adjectives per motion

for i1 = 1 : 124
    
    % adjectives
    
    adj_1_temp = data(i1).adjective_1;
    adj_1_temp(strcmp(adj_1_temp, '')) = {'-'};
    adj_all = [adj_1_temp data(i1).adjective_2 data(i1).adjective_3];
    adj_all = adj_all(~strcmp(adj_all, ''));
    data(i1).all_adjectives = adj_all;
    [adj, ind1, ind2] = unique(adj_all);
    data(i1).most_common_adjective = adj(mode(ind2));
    
    data(i1).adj_percentages = [];
    data(i1).adj_percentage_ind = [];
    uni_ind2 = unique(ind2);
    for i2 = 1 : length(uni_ind2)
        data(i1).adj_percentages = [data(i1).adj_percentages; sum(ind2(:) == uni_ind2(i2))];
        data(i1).adj_percentage_ind = [data(i1).adj_percentage_ind; find(strcmp(sorted_unique_adjectives, adj(uni_ind2(i2))), 1)];
    end
    data(i1).adj_percentages = data(i1).adj_percentages / length(ind2);
    data(i1).adj_percentages = cumsum(data(i1).adj_percentages);
    
end 

%% Plotting the clips interactively with the raw questionaire data

clips = motion_features' * coeff;

% Normalization after pca per person
clips(1:62, :) = clips(1:62, :) - repmat(mean(clips(1:62, :)), [size(clips(1:62, :), 1) 1]);
clips(62:124, :) = clips(62:124, :) - repmat(mean(clips(62:124, :)), [size(clips(62:124, :), 1) 1]);

%plot_these = 1:124;
plot_these = cellfun(@length, {data(:).verb}) >= 10;

fig = figure(3);
scatter3(clips(plot_these, 1), clips(plot_these, 2), clips(plot_these, 3), 20, zeros(sum(plot_these), 3), 'o', 'filled');
xlim([(min(min(clips))*1.1) (max(max(clips))*1.1)]);
ylim([(min(min(clips))*1.1) (max(max(clips))*1.1)]);

set(fig,'WindowButtonDownFcn', {@f_click_play_motion_3D_hilight, clips(plot_these, 1:3), data(plot_these)});
