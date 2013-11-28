% This demo shows how the words based data set can be loaded and how the
% precalculated motion features can be plotted.

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

%%

clear;

addpath('./libraries/MOCAP_manchester');
addpath('./libraries/MOCAP_manchester/NDLUTIL0p161');
addpath('./helper_functions');

%% Load motion data and precalculated features

load('motion_data_and_normalized_features.mat');

% The variable 'data' contains the following things for all the videos:
% filename: Name of the original bvh file containing the motion
% framelength: Number seconds between two frames
% skel: Skeleton structure and bone lengths
% bvhdata: Coordinates for the root joint and rotations as Euler angles for
% all joints for every frame
% xyz: coordinates of all the body part for each frame
% quaternions: Joint rotations as quaternions
% desc: Motion features the describe the motion (these is same as in
% the motion_features variable)

%% Reading the annotations for the videos from the text files

annotations = f_read_answers();

% The variable 'annotations' constains the raw data from the questionaire.
% Every index of the variable has the answers of one participant.

%% Create a big table with all the data

% In this part the annotations are cleaned up and stemmed manually (Finnish
% language only). Also, the data is stored in the variable 'big_table' so
% the every individual annotation has its own index. This is done because
% the data can be easier to plot and manipulate in this format.

for i1 = 1 : 124 % number of videos
    file_names{i1} = data(i1).filename(regexp(data(i1).filename, '/\S+.bvh') + 1 : length(data(i1).filename) - 4);
end

big_table = [];

row = 0;
for i1 = 1 : length(annotations)
    for i2 = 1: length(annotations(i1).verbs)
        
        row = row + 1;
        big_table(row).video = annotations(i1).videos{i2};
        big_table(row).verb = f_clean_up_finnish_verbs(lower(annotations(i1).verbs{i2}));
        big_table(row).adj1 = f_clean_up_finnish_adjectives(lower(annotations(i1).adjectives_1{i2}));
        big_table(row).adj2 = f_clean_up_finnish_adjectives(lower(annotations(i1).adjectives_2{i2}));
        big_table(row).adj3 = f_clean_up_finnish_adjectives(lower(annotations(i1).adjectives_3{i2}));
        big_table(row).participant_number = annotations(i1).participant_number;
        big_table(row).answers_in_language = lower(annotations(i1).answers_in_language);
        big_table(row).questions_in_language = annotations(i1).questions_in_language;
        big_table(row).age = annotations(i1).age;
        big_table(row).gender = annotations(i1).gender;
        big_table(row).profession_activity = annotations(i1).profession_activity;
        big_table(row).athlete = annotations(i1).athlete;
        big_table(row).dancer = annotations(i1).dancer;
        big_table(row).trainer = annotations(i1).trainer;
        big_table(row).instructor = annotations(i1).instructor;
        big_table(row).physiotherapis0t = annotations(i1).physiotherapist;
        big_table(row).other = annotations(i1).other;
        big_table(row).other_activity = lower(annotations(i1).other_activity);
        big_table(row).language = lower(annotations(i1).language);
        big_table(row).mother_tongue = annotations(i1).mother_tongue;
        big_table(row).language_skill = annotations(i1).language_skill;
        
        for i3 = 1 : 124 % number of videos
            if strcmp(big_table(row).video, file_names{i3})
                big_table(row).video_id = i3;
                big_table(row).feature_values = data(i3).desc;
            end
        end
        
    end
end

clear i1 i2 i3 row file_names;

%% Remove answers which are not in the Finnish language

big_table(~(strcmp({big_table.answers_in_language}, 'suomi'))) = [];

%% PCA and plotting the videos in the produced space

%[coeff, score, latent] = princomp(motion_features');

[coeff, score] = princomp_svm(motion_features', 128);

% Plotting the components and the video_coordinates
figure(1);
biplot(coeff(:,1:2),'Scores',score(:,1:2));

%% Plotting the videos in the PCA in 3D

video_coordinates = motion_features' * coeff;

plot_these = 1:124;

figure(2);
scatter3(video_coordinates(plot_these, 1), video_coordinates(plot_these, 2), video_coordinates(plot_these, 3), 20, 'o', 'filled');
xlim([(min(min(video_coordinates))*1.1) (max(max(video_coordinates))*1.1)]);
ylim([(min(min(video_coordinates))*1.1) (max(max(video_coordinates))*1.1)]);

