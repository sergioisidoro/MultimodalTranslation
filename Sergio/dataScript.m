load('finnishBigTable.mat');

verbs = {big_table(:).verb};
unique_verbs = unique(verbs);

clear verbs;

%% To do - Remove verbs that have less than x occurences


verb = [];

for i1 = 1 : 124
      
        for t = 1:100
           verb(t).value(1,1) = 0; 
        end
    
    for i2 = 1 : length(data(i1).verb_percentages)
        verb(data(i1).verb_percentage_ind(i2)).value(end+1,1)=dimension1(i1);
        verb(data(i1).verb_percentage_ind(i2)).value(end,2)=dimension2(i1);
        verb(data(i1).verb_percentage_ind(i2)).value(end,3)=data(i1).verb_percentages(i2);
    end
end


for c = 1:length(verb)
    
    cenas = verb(c).value;
    cenas(1,:) = [];
    [xi, yi] = meshgrid(-0.5:0.01:0.5, -0.5:0.01:0.5);
    zi = griddata(cenas(:,1),cenas(:,2), cenas(:,3), xi, yi)
    surf (xi,yi,zi)


    %% Fit: 'untitled fit 1'.
    [xData, yData, zData] = prepareSurfaceData( xi, yi, zi );

    % Set up fittype and options.
    ft = 'nearestinterp';
    opts = fitoptions( ft );
    opts.Normalize = 'on';

    % Fit model to data.
    [fitresult, gof] = fit( [xData, yData], zData, ft, opts );

    % Plot fit with data.
    figure( 'Name', 'untitled fit 1' );
    h = plot( fitresult, [xData, yData], zData );
    legend( h, 'untitled fit 1', 'zi vs. xi, yi', 'Location', 'NorthEast' );
    % Label axes
    xlabel( 'xi' );
    ylabel( 'yi' );
    zlabel( 'zi' );
    grid on
    view( 0.5, 54 );
    
    verb(c).fitResult = fitresult;
    verb(c).gof = gof;
end
