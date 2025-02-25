function f_click_play_motion_3D(src, evnt, pca_desc, data)

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

h = gca;
pos = get(h,'CurrentPoint');

for i = 1 : length(data)
    dist(i) = f_point_to_line(pca_desc(i, 1:3), pos(1, :), pos(2, :));
end

[~, clip_index] = min(dist);

if strcmp(get(src,'SelectionType'),'normal')
    name = data(clip_index).filename(regexp(data(clip_index).filename, '/\S+.bvh') + 1 : length(data(clip_index).filename) - 4);
    name = strrep(name,'_','-');
    title(['selected: ' name]);
    figure(100);
    bvhPlayData(data(clip_index).skel, data(clip_index).bvhdata(1:5:length(data(clip_index).bvhdata), :), 0.05);
end

end

