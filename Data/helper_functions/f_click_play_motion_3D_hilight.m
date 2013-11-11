function f_click_play_motion_3D_hilight(src, evnt, pca_desc, data)

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
    
    colors = zeros(length(data), 3);
    colors(clip_index, :) = [1 0 1];
    set(get(gca,'Children'), 'CData', colors);
    
    figure(101);
    clf(101);
    
    xlim([0 1]);
    ylim([0 1]);
    
    for i = 1 : length(data(clip_index).verb)
        text(0.01, 1.02 - (0.04*i), data(clip_index).verb(i));
        text(0.30, 1.02 - (0.04*i), data(clip_index).adjective_1(i));
        text(0.50, 1.02 - (0.04*i), data(clip_index).adjective_2(i));
        text(0.70, 1.02 - (0.04*i), data(clip_index).adjective_3(i));
    end
    
    set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    
    figure(100);
    bvhPlayData(data(clip_index).skel, data(clip_index).bvhdata(1:5:length(data(clip_index).bvhdata), :), 0.05);
end

end

