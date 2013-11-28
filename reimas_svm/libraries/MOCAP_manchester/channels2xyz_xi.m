function xyz =channels2xyz_xi(channels,skel)
% convert the whole annimation to a matrix Nframe*(3*joints) dimension 
nframe=size(channels,1);
njoints=length(skel.tree);
xyz=zeros(nframe,3*njoints);

for i=1:nframe
    temp1=skel2xyz(skel,channels(i,:));
    temp2=temp1';
    xyz(i,:)=temp2(:);
end