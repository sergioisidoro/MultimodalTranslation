function [ answers ] = f_read_answers( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

oldEncoding = slCharacterEncoding();
%slCharacterEncoding('ISO-8859-1');
slCharacterEncoding('UTF-8');

listing = dir('answers_new');
list = {listing(3:length(listing)).name}';

%%

for i_0 = 2 : size(list, 1)
    
    i = i_0 - 1; 
    
    fid = fopen(['answers_new/' list{i_0}]);
    
    temp = textscan(fid, '%s%f', 1);
    answers(i).participant_number = temp{2};
    
    temp = textscan(fid, '%s%s', 1);
    answers(i).questions_in_language = temp{2}{:};
    
    temp = textscan(fid, '%s%s', 1);
    answers(i).age = temp{2}{:};
    
    temp = textscan(fid, '%s%s', 1);
    answers(i).gender = temp{2}{:};
    
    temp = textscan(fid, '%s%s', 1);
    answers(i).profession_activity = temp{2}{:};
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).athlete = true;
    else
        answers(i).athlete = false;
    end
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).dancer = true;
    else
        answers(i).dancer = false;
    end
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).trainer = true;
    else
        answers(i).trainer = false;
    end
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).instructor = true;
    else
        answers(i).instructor = false;
    end
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).physiotherapist = true;
    else
        answers(i).physiotherapist = false;
    end
    
    temp = textscan(fid, '%s%s', 1);
    if (length(temp{2}{:}) > 1) 
        answers(i).other = true;
    else
        answers(i).other = false;
    end
    
    temp = fgetl(fid); % This returns only an empty string.
    temp = fgetl(fid);
    answers(i).other_activity = strrep(temp, 'other_activity ', '');
    
    for i1 = 1 : 5
        temp = fgetl(fid);
        if (length(temp) == 0)
            temp = fgetl(fid);
        end
        temp2 = textscan(temp, '%s');
        answers(i).language{i1} = strrep(temp, [temp2{:}{1}  ' '], '');
        
        temp = textscan(fid, '%s%s', 1);
        answers(i).language_skill{i1} = temp{2}{:};
        
        temp = textscan(fid, '%s%s', 1);
        if (strcmp(temp{2}{:}, 'yes'))
            answers(i).mother_tongue(i1) = true;
        else
            answers(i).mother_tongue(i1) = false;
        end
    end
    
    temp = textscan(fid, '%s%s', 1);
    answers(i).answers_in_language = temp{2}{:};
    
    temp = textscan(fid, '%s%f', 1);
    answers(i).survey_start_second = temp{2};

    temp = textscan(fid, '%s%s%s%s%s%f');
    answers(i).videos = temp{1};
    answers(i).verbs = temp{2};
    answers(i).adjectives_1 = temp{3};
    answers(i).adjectives_2 = temp{4};
    answers(i).adjectives_3 = temp{5};
    answers(i).seconds = temp{6};
    
    fclose(fid);

end

slCharacterEncoding(oldEncoding);

end

