% This demo shows how the motion features can be calculated. This can be
% useful if you are not satisfied with the precalculated feature set. This
% file also contains the code and visualization of the normalization of
% features between the two actors.

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

%%

clear;

addpath('./libraries/MOCAP_manchester');
addpath('./libraries/MOCAP_manchester/NDLUTIL0p161');

%% Load motion data

load('motion_data_and_normalized_features.mat');

% Remove the precalculated features
clear motion_features
for i = 1 : length(data)
    data(i).desc = [];
end

%% Feature calculations

% This code calculate new features for each frame of the motions and then
% averages the descriptors over time by taking means and standard
% deviations. The calculations can be a bit slow.

motion_features_raw = [];

for i = 1 : length(data)
    disp([num2str(i) '/' num2str(length(data))])
    % The following line produces the default set of motion features.
    features = f_calculate_descriptors(data(i).skel, data(i).xyz, data(i).bvhdata, [1 1 1 1 1 0 1 0 0]);
    features = [mean(features) std(features)]';
    motion_features_raw = [motion_features_raw features];
end

motion_features_raw = motion_features_raw';

%% Plotting the raw motion features as such

[coeff, score, latent] = princomp(motion_features_raw);

raw_pca_features = motion_features_raw * coeff;

actor_K = 1:62;
actor_T = 63:124;

figure(3);
scatter3(raw_pca_features(actor_K, 1), raw_pca_features(actor_K, 2), raw_pca_features(actor_K, 3), 20, [1 0 0], 'o', 'filled');
xlim([(min(min(raw_pca_features(:, 1)))*1.1) (max(max(raw_pca_features(:, 1)))*1.1)]);
ylim([(min(min(raw_pca_features(:, 2)))*1.1) (max(max(raw_pca_features(:, 2)))*1.1)]);
zlim([(min(min(raw_pca_features(:, 3)))*1.1) (max(max(raw_pca_features(:, 3)))*1.1)]);
hold on;
scatter3(raw_pca_features(actor_T, 1), raw_pca_features(actor_T, 2), raw_pca_features(actor_T, 3), 20, [0 0 1], 'o', 'filled');
hold off;
legend({'actor K', 'actor T'});
title('motion features as such');

%% Normalizing the features per person and plotting again

motion_features_norm = motion_features_raw;

actor_K = 1:62;
actor_T = 63:124;

m_k = mean(motion_features_raw(actor_K, :));
s_k = std(motion_features_raw(actor_K, :));
m_t = mean(motion_features_raw(actor_T, :));
s_t = std(motion_features_raw(actor_T, :));

for i1 = 1 : 602
    motion_features_norm(actor_K, i1) = motion_features_norm(actor_K, i1) - m_k(i1);
    motion_features_norm(actor_K, i1) = motion_features_norm(actor_K, i1) ./ s_k(i1);
    
    motion_features_norm(actor_T, i1) = motion_features_norm(actor_T, i1) - m_t(i1);
    motion_features_norm(actor_T, i1) = motion_features_norm(actor_T, i1) ./ s_t(i1);
end

[coeff, score, latent] = princomp(motion_features_norm);

norm_pca_features = motion_features_norm * coeff;

actor_K = 1:62;
actor_T = 63:124;

figure(4);
scatter3(norm_pca_features(actor_K, 1), norm_pca_features(actor_K, 2), norm_pca_features(actor_K, 3), 20, [1 0 0], 'o', 'filled');
xlim([(min(min(norm_pca_features(:, 1)))*1.1) (max(max(norm_pca_features(:, 1)))*1.1)]);
ylim([(min(min(norm_pca_features(:, 2)))*1.1) (max(max(norm_pca_features(:, 2)))*1.1)]);
zlim([(min(min(norm_pca_features(:, 3)))*1.1) (max(max(norm_pca_features(:, 3)))*1.1)]);
hold on;
scatter3(norm_pca_features(actor_T, 1), norm_pca_features(actor_T, 2), norm_pca_features(actor_T, 3), 20, [0 0 1], 'o', 'filled');
hold off;
legend({'actor K', 'actor T'});
title('motion features after normalization');

%% Load feature names

load('feature_names_602.mat');

% The variable 'feature_names' contains the names of each feature in the
% default set. 
