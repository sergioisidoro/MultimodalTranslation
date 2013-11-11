function channelsm=channels2meter_xi(channels)
% convert the first three column which are positions to meter
channelsm=channels;

scale=0.45;
factor=1/scale*2.54/100;

channelsm(:,1:3)=channels(:,1:3)*factor;
