% This demo plots the figures in the paper 'Impact of Varying Vocabularies
% on Controlling Motion of a Virtual Actor'. This file provided mainly as
% extra visualization as the code itself is not easily reusable.

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

%%

%clear;

%addpath('./libraries/MOCAP_manchester');
%addpath('./libraries/MOCAP_manchester/NDLUTIL0p161');
%addpath('./helper_functions');

%load('motion_data_and_normalized_features.mat');

%% Reduce dimensionality and plot

%[coeff, score] = princomp(motion_features', 0);

%clips = motion_features' * coeff;

%% Read the annotations

annotations = f_read_answers();

%% Create a big table with the data


for i1 = 1 : 124 % number of videos
    file_names{i1} = data(i1).filename(regexp(data(i1).filename, '/\S+.bvh') + 1 : length(data(i1).filename) - 4);
end

big_table = [];

row = 0;
for i1 = 1 : length(annotations)
    for i2 = 1: length(annotations(i1).verbs)
        
        row = row + 1;
        big_table(row).video = annotations(i1).videos{i2};
        big_table(row).verb = lower(annotations(i1).verbs{i2});
        big_table(row).adj1 = lower(annotations(i1).adjectives_1{i2});
        big_table(row).adj2 = lower(annotations(i1).adjectives_2{i2});
        big_table(row).adj3 = lower(annotations(i1).adjectives_3{i2});
        big_table(row).participant_number = annotations(i1).participant_number;
        big_table(row).answers_in_language = lower(annotations(i1).answers_in_language);
        disp(big_table(row).answers_in_language);
        big_table(row).questions_in_language = annotations(i1).questions_in_language;
        big_table(row).age = annotations(i1).age;
        big_table(row).gender = annotations(i1).gender;
        big_table(row).profession_activity = annotations(i1).profession_activity;
        big_table(row).athlete = annotations(i1).athlete;
        big_table(row).dancer = annotations(i1).dancer;
        big_table(row).trainer = annotations(i1).trainer;
        big_table(row).instructor = annotations(i1).instructor;
        big_table(row).physiotherapist = annotations(i1).physiotherapist;
        big_table(row).other = annotations(i1).other;
        big_table(row).other_activity = lower(annotations(i1).other_activity);
        big_table(row).language = lower(annotations(i1).language);
        big_table(row).mother_tongue = annotations(i1).mother_tongue;
        big_table(row).language_skill = annotations(i1).language_skill;
        
        big_table(row).answers_in_language
        
        for i3 = 1 : 124 % number of videos
            if strcmp(big_table(row).video, file_names{i3})
                big_table(row).video_id = i3;
                big_table(row).clip_pca_values = clips(i3, :);
            end
        end
        
        
    end
end

big_table(~(strcmp({big_table.answers_in_language}, 'english'))) = [];



%%

%clear annotations coeff motion_features file_names i1 i2 i3 latent row score;

%% Combining different word forms

for i1 = 1 : length(big_table)
    big_table(i1).verb = f_clean_up_english_verbs(big_table(i1).verb);
    big_table(i1).adj1 = f_clean_up_english_adjectives(big_table(i1).adj1);
    big_table(i1).adj2 = f_clean_up_english_adjectives(big_table(i1).adj2);
    big_table(i1).adj3 = f_clean_up_english_adjectives(big_table(i1).adj3);
end

%% How much variety exists in the annotations?
%   ~ Can the freely selected words be replaced by forced choice alternatives?
%   ~ How many alternatives would be needed to cover most of the cases for the eng_verbs and the adjectives?

%big_table = big_table(cellfun(@(x) ~isempty(strfind(x, '100')), {big_table(:).video}));

eng_verbs = {big_table(:).verb};
unique_eng_verbs = unique(eng_verbs);
eng_verb_usage = cellfun(@(x) sum(strcmp(eng_verbs, x)), unique_eng_verbs);
eng_verb_usage_cumulative = cumsum(sort(eng_verb_usage, 'descend')) / length(eng_verbs) * 100;

unique_eng_verbs
for i1 = 1 : length(unique_eng_verbs)
    temp_table = big_table(strcmp({big_table(:).verb}, unique_eng_verbs(i1)));
    persons = unique([temp_table(:).participant_number]);
    eng_verb_used_by_persons(i1) = length(persons);
end

eng_verbs_used_by_persons_cumulative = cumsum(sort(eng_verb_used_by_persons, 'descend')) / sum(eng_verb_used_by_persons) * 100;

clear eng_verb_table;
eng_verb_table(:, 1) = unique_eng_verbs';
eng_verb_table(:, 2) = num2cell(eng_verb_usage)';
eng_verb_table(:, 3) = num2cell(eng_verb_used_by_persons)';
eng_verb_table = sortrows(eng_verb_table, -2);
eng_verb_table_2 = sortrows(eng_verb_table, -3);

adjectives = {big_table(:).adj1 big_table(:).adj2 big_table(:).adj3};
adjectives(strcmp(adjectives, '_')) = [];
unique_adj = unique(adjectives);
eng_adjectives_usage = cellfun(@(x) sum(strcmp(adjectives, x)), unique_adj);
eng_adjectives_usage_cumulative = cumsum(sort(eng_adjectives_usage, 'descend')) / length(adjectives) * 100;

for i1 = 1 : length(unique_adj)
    temp_table = big_table( ...
        strcmp({big_table(:).adj1}, unique_adj(i1)) | ...
        strcmp({big_table(:).adj2}, unique_adj(i1)) | ...
        strcmp({big_table(:).adj3}, unique_adj(i1)));
    persons = unique([temp_table(:).participant_number]);
    eng_adjectives_used_by_persons(i1) = length(persons);
end

eng_adjectives_used_by_persons_cumulative = cumsum(sort(eng_adjectives_used_by_persons, 'descend')) / sum(eng_adjectives_used_by_persons) * 100;

clear adjective_table;
adjective_table(:, 1) = unique_adj';
adjective_table(:, 2) = num2cell(eng_adjectives_usage)';
adjective_table(:, 3) = num2cell(eng_adjectives_used_by_persons)';
adjective_table = sortrows(adjective_table, -2);
adjective_table_2 = sortrows(adjective_table, -3);

%%

figure(20)
plot(eng_adjectives_used_by_persons_cumulative, 'r--');
hold on;
plot(eng_verbs_used_by_persons_cumulative, 'b-');
hold off;
xlabel('words');
ylabel('cum. % of persons using the words');
legend({'modifiers', 'eng_verbs'});

%% How subjective are the eng_verbs and adjectives?
%   ~ If only one person would do the annotation, how much of the variety would be lost?

% Create the shared vocabulary => if word A is used by 10 people it is 10 time in the shared vocabulary

% Consider only the original 24 videos
temp_table = big_table(cellfun(@(x) ~isempty(strfind(x, '100')), {big_table(:).video}));

person_ids = unique([big_table(:).participant_number]);

shared_eng_verbs = [];
shared_adjectives = [];

for i1 = 1 : length(unique(person_ids))
    temp_eng_verbs = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).verb});
    temp_adj1 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj1});
    temp_adj2 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj2});
    temp_adj3 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj1});
    temp_adj = unique([temp_adj1 temp_adj2 temp_adj3]);
    
    shared_eng_verbs = [shared_eng_verbs temp_eng_verbs];
    shared_adjectives = [shared_adjectives temp_adj];
end

number_of_used_eng_verbs = [];
number_of_answered_videos = [];
number_of_used_words_per_video = [];

for i1 = 1 : length(unique(person_ids))
    temp_eng_verbs = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).verb});
    temp_adj1 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj1});
    temp_adj2 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj2});
    temp_adj3 = unique({temp_table([temp_table(:).participant_number] == person_ids(i1)).adj1});
    temp_adj = unique([temp_adj1 temp_adj2 temp_adj3]);
    number_of_used_eng_verbs(i1) = length(temp_eng_verbs);
    number_of_used_adj(i1) = length(temp_adj);
    
    number_of_eng_verbs_covered(i1) = 0;
    for i2 = 1 : length(shared_eng_verbs)
        for i3 = 1 : length(temp_eng_verbs)
            if strcmp(shared_eng_verbs(i2), temp_eng_verbs(i3))
                number_of_eng_verbs_covered(i1) = number_of_eng_verbs_covered(i1) + 1;
            end
        end
    end
    
    number_of_adjs_covered(i1) = 0;
    for i2 = 1 : length(shared_adjectives)
        for i3 = 1 : length(temp_adj)
            if strcmp(shared_adjectives(i2), temp_adj(i3))
                number_of_adjs_covered(i1) = number_of_adjs_covered(i1) + 1;
            end
        end
    end
    
end

mean_number_of_used_eng_verbs = mean(number_of_used_eng_verbs);
std_number_of_used_eng_verbs = std(number_of_used_eng_verbs);
mean_number_of_used_adj = mean(number_of_used_adj);
std_number_of_used_adj = std(number_of_used_adj);

% actor words
temp_eng_verbs = {'juoksee_' 'kävelee_' 'ontuu_'};
temp_adj = {'hitaasti_' 'surullisesti_' 'nopeasti_' 'tavallisesti_' 'vihaisesti_'};
number_of_eng_verbs_covered_actor = 0;
for i2 = 1 : length(shared_eng_verbs)
    for i3 = 1 : length(temp_eng_verbs)
        if strcmp(shared_eng_verbs(i2), temp_eng_verbs(i3))
            number_of_eng_verbs_covered_actor = number_of_eng_verbs_covered_actor + 1;
        end
    end
end
number_of_adjs_covered_actor = 0;
for i2 = 1 : length(shared_adjectives)
    for i3 = 1 : length(temp_adj)
        if strcmp(shared_adjectives(i2), temp_adj(i3))
            number_of_adjs_covered_actor = number_of_adjs_covered_actor + 1;
        end
    end
end

coverage_percents = [ 
    (number_of_eng_verbs_covered_actor / length(shared_eng_verbs))*100 (3/length(eng_verbs_used_by_persons_cumulative))*100
    (number_of_adjs_covered_actor / length(shared_adjectives))*100 (5/length(eng_adjectives_used_by_persons_cumulative))*100
    mean(number_of_eng_verbs_covered / length(shared_eng_verbs))*100 (mean_number_of_used_eng_verbs/length(eng_verbs_used_by_persons_cumulative))*100
    mean(number_of_adjs_covered / length(shared_adjectives))*100 (mean_number_of_used_adj/length(eng_adjectives_used_by_persons_cumulative))*100
    ];

errors = [ 
    0 0
    0 0
    std(number_of_eng_verbs_covered / length(shared_eng_verbs))*100 (std_number_of_used_eng_verbs/length(eng_verbs_used_by_persons_cumulative))*100
    std(number_of_adjs_covered / length(shared_adjectives))*100 (std_number_of_used_adj/length(eng_adjectives_used_by_persons_cumulative))*100
       ];

%%

figure(21);
colormap summer;
bar(coverage_percents);
f_errorb(coverage_percents, errors, 'linewidth', 1);
ylim([0 100]);
xlim([0.5 4.5]);
ylabel('% of covered vocabulary');
%set(gca, 'XTickLabel', {'acted eng_verbs', 'acted adjectives', 'annotated eng_verbs', 'annotated adjectives'});
legend('shared vocabulary', 'plain vocabulary');
f_xticklabels([1 2 3 4], {{'acted','eng_verbs'}, {'acted','modifiers'}, {'annotated','eng_verbs'}, {'annotated','modifiers'}});

%% Common eng_verbs, adjectives and verb-adjective pairs

% A verb without any adjectives counts only as one verb-adjective pair.

eng_verb_adj_list = [];
eng_verb_list = [];
adj_list = [];

index = 0;
index_eng_verbs = 0;
index_adj = 0;
for i1 = 1 : length(big_table)
    
    index_eng_verbs = index_eng_verbs + 1;
    eng_verb_list{index_eng_verbs, 1} = big_table(i1).verb;
    eng_verb_list{index_eng_verbs, 2} = big_table(i1).participant_number;
    eng_verb_list{index_eng_verbs, 3} = big_table(i1).video_id;
    
    if (length(big_table(i1).adj1) > 1)
        index = index + 1;
        eng_verb_adj_list{index, 1} = [big_table(i1).verb big_table(i1).adj1];
        eng_verb_adj_list{index, 2} = big_table(i1).participant_number;
        eng_verb_adj_list{index, 3} = big_table(i1).video_id;
        
        index_adj = index_adj + 1;
        adj_list{index_adj, 1} = big_table(i1).adj1;
        adj_list{index_adj, 2} = big_table(i1).participant_number;
        adj_list{index_adj, 3} = big_table(i1).video_id;
    end
    if (length(big_table(i1).adj2) > 1)
        index = index + 1;
        eng_verb_adj_list{index, 1} = [big_table(i1).verb big_table(i1).adj2];
        eng_verb_adj_list{index, 2} = big_table(i1).participant_number;
        eng_verb_adj_list{index, 3} = big_table(i1).video_id;
        
        index_adj = index_adj + 1;
        adj_list{index_adj, 1} = big_table(i1).adj2;
        adj_list{index_adj, 2} = big_table(i1).participant_number;
        adj_list{index_adj, 3} = big_table(i1).video_id;
    end
    if (length(big_table(i1).adj3) > 1)
        index = index + 1;
        eng_verb_adj_list{index, 1} = [big_table(i1).verb big_table(i1).adj3];
        eng_verb_adj_list{index, 2} = big_table(i1).participant_number;
        eng_verb_adj_list{index, 3} = big_table(i1).video_id;
        
        index_adj = index_adj + 1;
        adj_list{index_adj, 1} = big_table(i1).adj3;
        adj_list{index_adj, 2} = big_table(i1).participant_number;
        adj_list{index_adj, 3} = big_table(i1).video_id;
    end
    if (length(big_table(i1).adj1) == 1 && length(big_table(i1).adj2) == 1 && length(big_table(i1).adj3) == 1)
        index = index + 1;
        eng_verb_adj_list{index, 1} = [big_table(i1).verb big_table(i1).adj1];
        eng_verb_adj_list{index, 2} = big_table(i1).participant_number;
        eng_verb_adj_list{index, 3} = big_table(i1).video_id;
        
        index_adj = index_adj + 1;
        adj_list{index_adj, 1} = big_table(i1).adj1;
        adj_list{index_adj, 2} = big_table(i1).participant_number;
        adj_list{index_adj, 3} = big_table(i1).video_id;
    end
end

%% Counts

% Verb-adjective pairs

eng_verb_adj_counts = unique(eng_verb_adj_list(:, 1));
for i1 = 1: length(eng_verb_adj_counts)
    eng_verb_adj_counts(i1, 2) = {sum(strcmp(eng_verb_adj_counts(i1, 1), eng_verb_adj_list(:, 1)))};
    eng_verb_adj_counts(i1, 3) = {length(unique([eng_verb_adj_list{strcmp(eng_verb_adj_counts(i1, 1), eng_verb_adj_list(:, 1)), 2}]))};
end

eng_verb_adj_counts_2 = sortrows(eng_verb_adj_counts, -2);
eng_verb_adj_counts_3 = sortrows(eng_verb_adj_counts, -3);

% eng_verbs

eng_verb_counts = unique(eng_verb_list(:, 1));
for i1 = 1: length(eng_verb_counts)
    eng_verb_counts(i1, 2) = {sum(strcmp(eng_verb_counts(i1, 1), eng_verb_list(:, 1)))};
    eng_verb_counts(i1, 3) = {length(unique([eng_verb_list{strcmp(eng_verb_adj_counts(i1, 1), eng_verb_list(:, 1)), 2}]))};
end

eng_verb_counts_2 = sortrows(eng_verb_counts, -2);
eng_verb_counts_3 = sortrows(eng_verb_counts, -3);

% Adjectives

adj_counts = unique(adj_list(:, 1));
for i1 = 1: length(adj_counts)
    adj_counts(i1, 2) = {sum(strcmp(adj_counts(i1, 1), adj_list(:, 1)))};
    adj_counts(i1, 3) = {length(unique([adj_list{strcmp(adj_counts(i1, 1), adj_list(:, 1)), 2}]))};
end

adj_counts_2 = sortrows(adj_counts, -2);
adj_counts_3 = sortrows(adj_counts, -3);

%% Plot settings

pie_size = 0.10;
label_count = 9;

%% Plotting eng_verbs

eng_verb_index = eng_verb_counts_2(:, 1);

for i1 = 1 : 124
    
    [eng_verbs, ind1, ind2] = unique(eng_verb_list([eng_verb_list{:, 3}] == i1, 1));
    
    data(i1).eng_verb_count = sum([eng_verb_list{:, 3}] == i1);
    
    data(i1).eng_verb_percentages = [];
    data(i1).eng_verb_percentage_ind = [];
    uni_ind2 = unique(ind2);
    for i2 = 1 : length(uni_ind2)
        data(i1).eng_verb_percentages = [data(i1).eng_verb_percentages; sum(ind2(:) == uni_ind2(i2))];
        data(i1).eng_verb_percentage_ind = [data(i1).eng_verb_percentage_ind; find(strcmp(eng_verb_index, eng_verbs(uni_ind2(i2))), 1)];
    end
    data(i1).eng_verb_percentages = data(i1).eng_verb_percentages / length(ind2);
    data(i1).eng_verb_percentages = cumsum(data(i1).eng_verb_percentages);
    
end

%% Adjusting colors

colormap('colorcube');
colors = colormap;
colors = colors([50 25 32  9 36 44 1 2 4 8 10 7 11 12 13 14 15 5 3 6 16 17 ...
    18 19 20 21 22 23 24 26 27 28 29 30 31 33 34 35 37 38 39 40 41 42 43 45 ...
    46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 62 63 64], :);
colors(14, :) = colors(4, :);
colors(4, :) = colors(38, :);
colors(8, :) = colors(56, :);
colors(5, :) = colors(40, :);
temp_c = colors(10, :);
colors(10, :) = colors(14, :);
colors(2, :) = temp_c;

% for i1 = 1 : 5
%     i2 = i1 - 1;
%     colors(i1, :) = [i2/5 i2/5 i2/5];
% end


%% Adjusting pie positions

pie_size = 0.013; % was 0.012 in the long version of the paper

dimension1 = clips(:, 1) ./ range(clips(:, 1));
dimension2 = clips(:, 2) ./ range(clips(:, 2));

scale_fix = 1;

for i0 = 1:250
    for i1 = 1 : length(dimension1)
        for i2 = i1+1 : length(dimension1)
            center1 = (dimension1(i1) + dimension1(i2)) / 2;
            center2 = (dimension2(i1) + dimension2(i2)) / 2;
            distance = sqrt((dimension1(i1) - dimension1(i2))^2 + (dimension2(i1) - dimension2(i2))^2);
            desired_distance = (pie_size * sqrt(data(i1).eng_verb_count*0.4)) + (pie_size * sqrt(data(i2).eng_verb_count*0.4));
            ratio = desired_distance / distance;
            
            if (distance < desired_distance)
                
                disp([num2str(i1) ' ' num2str(i2) ' ' num2str(distance) ' ' num2str(desired_distance)]);
                
                dimension1(i1) = dimension1(i1) + ((dimension1(i1) - center1) * ratio * 0.05);
                dimension1(i2) = dimension1(i2) + ((dimension1(i2) - center1) * ratio * 0.05);
                dimension2(i1) = dimension2(i1) + ((dimension2(i1) - center2) * ratio * 0.05);
                dimension2(i2) = dimension2(i2) + ((dimension2(i2) - center2) * ratio * 0.05);
            end
        end
    end
end

dimension1 = dimension1 ./ range(dimension1);
dimension2 = dimension2 ./ range(dimension2);

%%

figure(10);
clf(10);
hold on;

xlim([((min(dimension1)) - 0.05) ((max(dimension1)) + 0.05)]);
ylim([((min(dimension2)) - 0.05) ((max(dimension2)) + 0.05)]);

scale_fix = 1;

for i1 = 1 : 124
    for i2 = 1 : length(data(i1).eng_verb_percentages)
        radius = pie_size * sqrt(data(i1).eng_verb_count*0.4);
        offset_x = dimension1(i1);
        offset_y = dimension2(i1);
        if (i2 == 1)
            pie_start = 0;
        else
            pie_start = data(i1).eng_verb_percentages(i2-1);
        end
        
        pie_end = data(i1).eng_verb_percentages(i2);
        
        if (data(i1).eng_verb_percentage_ind(i2) < label_count+1)
            color_index = data(i1).eng_verb_percentage_ind(i2);
        else
            color_index = 64;
        end
        
        f_draw_pie( radius, offset_x, offset_y, pie_start, pie_end, scale_fix, colors(color_index, 1:3) )
    end
end

axis square;

hold off;

english_translations_of_eng_verbs = {
'walks - kävelee'
'limps - ontuu'
'runs - juoksee'
'limps - nilkuttaa'
'jogs - hölkkää'
'limps - linkuttaa'
'scuffs - laahustaa'
'steps - askeltaa'
'marches - marssii'
%'sneaks'% - hiipii'
%'dawdles'    % 'löntystelee_'
%'proceeds'    % 'etenee_'
%'loiters'    % 'maleksii_'
%'slogs'   % 'raahustaa_'
%'limps'    % 'linkkaa_'
%'steps'    % 'astelee_'
};

%hleg = legend(strrep([eng_verb_index(1:label_count+1); '"other"'], '_', '-'));
hleg = legend([english_translations_of_eng_verbs; '"other"']);
legend_markers = findobj(get(hleg, 'Children'), 'FaceLighting', 'flat');
for i = 2 : label_count+1
    set(legend_markers(i), 'FaceColor', colors(label_count+2-i, 1:3));
end
set(legend_markers(1), 'FaceColor', colors(64, 1:3));

%% Modifier statistics for plotting

adj_index = adj_counts_2(:, 1);

for i1 = 1 : 124
    
    [adjs, ind1, ind2] = unique(adj_list([adj_list{:, 3}] == i1, 1));
    
    data(i1).adjs_count = sum([adj_list{:, 3}] == i1);
    
    data(i1).adj_percentages = [];
    data(i1).adj_percentage_ind = [];
    uni_ind2 = unique(ind2);
    for i2 = 1 : length(uni_ind2)
        data(i1).adj_percentages = [data(i1).adj_percentages; sum(ind2(:) == uni_ind2(i2))];
        data(i1).adj_percentage_ind = [data(i1).adj_percentage_ind; find(strcmp(adj_index, adjs(uni_ind2(i2))), 1)];
    end
    data(i1).adj_percentages = data(i1).adj_percentages / length(ind2);
    data(i1).adj_percentages = cumsum(data(i1).adj_percentages);
    
end

%%

figure(11);
clf(11);
hold on;

xlim([((min(dimension1)) - 0.05) ((max(dimension1)) + 0.05)]);
ylim([((min(dimension2)) - 0.05) ((max(dimension2)) + 0.05)]);

for i1 = 1 : 124
    for i2 = 1 : length(data(i1).adj_percentages)
        radius = pie_size * sqrt(data(i1).eng_verb_count*0.4);
        offset_x = dimension1(i1);
        offset_y = dimension2(i1);
        if (i2 == 1)
            pie_start = 0;
        else
            pie_start = data(i1).adj_percentages(i2-1);
        end
        
        pie_end = data(i1).adj_percentages(i2);
        
        if (data(i1).adj_percentage_ind(i2) <label_count+1)
            color_index = data(i1).adj_percentage_ind(i2);
        else
            color_index = 64;
        end
        
        f_draw_pie( radius, offset_x, offset_y, pie_start, pie_end, scale_fix, colors(color_index, 1:3) )
    end
end

axis square;

hold off;

english_translations_of_adjectives = {
'-'    % '_'
'slowly - hitaasti'
'relaxedly - rennosti'
'limpingly - ontuvasti'
'briskly - reippaasti'
'laboriously - vaivalloisesti'
'calmly - rauhallisesti'
'cautiously - varovasti'
'painfully - kivuliaasti'
%'sadly - surullisesti'
%'fastly'    % 'nopeasti_'
%'hurriedly'    % 'kiirehtien_'
%'normally'    % 'normaalisti_'
%'vigorously'    % 'tarmokkaasti_'
%'determinedly'    % 'määrätietoisesti_'
%'confidently'    % 'itsevarmasti_'
};


%hleg = legend(strrep([adj_index(1:label_count+1); '"other"'], '_', '-'));
hleg = legend([english_translations_of_adjectives; '"other"']);
legend_markers = findobj(get(hleg, 'Children'), 'FaceLighting', 'flat');
for i = 2 : label_count+1
    set(legend_markers(i), 'FaceColor', colors(label_count+2-i, 1:3));
end
set(legend_markers(1), 'FaceColor', colors(64, 1:3));


%% Plotting eng_verb_adjective pairs

eng_verb_adj_index = eng_verb_adj_counts_2(:, 1);

for i1 = 1 : 124
    
    [eng_verb_adjs, ind1, ind2] = unique(eng_verb_adj_list([eng_verb_adj_list{:, 3}] == i1, 1));
    
    data(i1).eng_verb_adjs_count = sum([eng_verb_adj_list{:, 3}] == i1);
    
    data(i1).eng_verb_adj_percentages = [];
    data(i1).eng_verb_adj_percentage_ind = [];
    uni_ind2 = unique(ind2);
    for i2 = 1 : length(uni_ind2)
        data(i1).eng_verb_adj_percentages = [data(i1).eng_verb_adj_percentages; sum(ind2(:) == uni_ind2(i2))];
        data(i1).eng_verb_adj_percentage_ind = [data(i1).eng_verb_adj_percentage_ind; find(strcmp(eng_verb_adj_index, eng_verb_adjs(uni_ind2(i2))), 1)];
    end
    data(i1).eng_verb_adj_percentages = data(i1).eng_verb_adj_percentages / length(ind2);
    data(i1).eng_verb_adj_percentages = cumsum(data(i1).eng_verb_adj_percentages);
    
end

%%% SVM code:

dim=2;
countthr=1;

eng_obsdata=[];
eng_classdata=[];
eng_classdata2d=[];
eng_class=0;

for v=1:length(eng_verb_index)
 eng_verb=eng_verb_index{v};
 eng_verbdata=[];
 for i=1:length(eng_verb_list)
  if strcmp(eng_verb_list{i,1},eng_verb)
    if length(eng_verbdata>0)
        eng_verbdata=[eng_verbdata; motion_features(:,eng_verb_list{i,3})'];
        eng_verbdata2d=[eng_verbdata2d; coeff(eng_verb_list{i,3},1:dim)];
    else
      eng_verbdata =motion_features(:,eng_verb_list{i,3})';
      eng_verbdata2d = coeff(eng_verb_list{i,3},1:dim);
    end
  end
 end
 if (size(eng_verbdata,1) > countthr)
   eng_class=eng_class+1
   if length(eng_classdata>0)   
      eng_obsdata=[eng_obsdata; mean(eng_verbdata)];
      eng_classdata=[eng_classdata; eng_class];
   else
%      eng_obsdata=eng_verbdata;
%      eng_classdata=eng_class*ones(size(eng_verbdata,1),1);
%      eng_classdata2d=eng_class*ones(size(eng_verbdata2d,1),1);
      eng_obsdata=mean(eng_verbdata)
      eng_classdata=eng_class
   end
 end
end

%svmlarge=svmtrain(eng_obsdata,eng_classdata,'method','QP')
%svm2d=svmtrain(eng_obsdata,eng_classdata2d,'method','QP','showplot','1')


% Write the data for processing with multi-SVM:
strings={'#comment line'};
for i=1:size(eng_obsdata,1)
    disp(i);
    shstr=num2str(eng_classdata(i));
    for j=1:size(eng_obsdata,2)
        shstr=[shstr,' ',num2str(j),':',num2str(eng_obsdata(i,j))];
    end
    strings{i}=shstr;
end

%save('en_obs.data','strings','-ascii')

fid = fopen('eng_obs_means.txt', 'w');
for row=1:length(strings)
    fprintf(fid, '%s \n', strings{row});
end
fclose(fid); 