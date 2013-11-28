function klausSkelPlayData(skelStruct, channels, frameLength, coordinate_data)

% SKELPLAYDATA Play skel motion capture data.
%
%	Description:
%
%	SKELPLAYDATA(SKEL, CHANNELS, FRAMELENGTH) plays channels from a
%	motion capture skeleton and channels.
%	 Arguments:
%	  SKEL - the skeleton for the motion.
%	  CHANNELS - the channels for the motion.
%	  FRAMELENGTH - the framelength for the motion.
%	
%
%	See also
%	BVHPLAYDATA, ACCLAIMPLAYDATA


%	Copyright (c) 2006 Neil D. Lawrence
% 	skelPlayData.m CVS version 1.2
% 	skelPlayData.m SVN version 42
% 	last update 2008-08-12T20:23:47.000000Z

if nargin < 3
  frameLength = 1/120;
end
clf

handle = skelVisualise(channels(1, :), skelStruct);


% Limits of the motion.
xlim = [-100 100];
ylim = [-100 100];
zlim = [-100 100];
set(gca, 'xlim', xlim, ...
         'ylim', ylim, ...
         'zlim', zlim);
     
% Play the motion
for j = 1:size(channels, 1)
  pause(frameLength)
  klaus2SkelModify(handle, coordinate_data(j, :), skelStruct);
end
