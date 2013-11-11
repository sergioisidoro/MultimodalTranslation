function skelm=skel2meter_xi(skel)
% convert the offset in skel to meter
skelm=skel;
num=length(skel.tree);
scale=0.45;
factor=1/scale*2.54/100;
for i=1:num
    skelm.tree(1,i).offset=factor*skel.tree(1,i).offset;
end