% addpath of NDLUTIL toolbox
addpath ./NDLUTIL0p161/
% loading a BVH data set from the examples directory.
[skel, channels, frameLength] = bvhReadFile('examples/Swagger.bvh');
% play the data using the command
skelPlayData(skel, channels, frameLength);

% play with real data from dev01
addpath /home/xi/work/liikekieli/data/dev01/
[skel, channels, frameLength] = bvhReadFile('dev01_1.bvh');
skelPlayData(skel, channels, frameLength);