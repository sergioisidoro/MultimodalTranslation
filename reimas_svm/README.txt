This data set was used in the paper titled 'Impact of Varying Vocabularies
on Controlling Motion of a Virtual Actor'.

./answers_new - Contains the raw text files from the questionnaire about
naming human movement (https://mediatech.aalto.fi/~kvlehton/gica_eng/).

./helper_functions - Contains some Matlab functions needed by the demos.
Note that some of the file are copyrighted as it is said in their
disclaimers.

./interpolated - This folder contains the raw motion data in bvh files.
In the naming of the files there is the names of the original files and the
interpolation percentages. For example the file k_limp_sad_k_walk_sad_025_075
is 25% of motion 'k_limp_sad' and 75% of motion k_walk_sad.

./libraries - Contains slightly modified version of the Mocap Toolbox
developed at Manchester University.

demo_1.m - This demo shows how the words based data set can be loaded and
how the precalculated motion features can be plotted.

demo_2.m - This demo shows how the motion features can be calculated. This
can be useful if you are not satisfied with the precalculated feature set.
This file also contains the code and visualization of the normalization of
features between the two actors.

demo_3.m - This demo plots some statistics about the questionnaire
answers.

demo_4.m - This demo is an interactive visualization of the motion data
with a stick figure animation and the demo also shows the raw questionnaire
data. Some of the code used in building the user interface is a bit messy.

demo_5.m - This demo plots the figures in the paper 'Impact of Varying
Vocabularies on Controlling Motion of a Virtual Actor'. This file provided
mainly as extra visualization as the code itself is not easily reusable.

features_names_602.mat - Names for the features in the default feature set.

motion_data_and_normalized_features.mat - All the motion data and default
features.


Klaus Förger, Department of Media Technology, Aalto University, 2013 
