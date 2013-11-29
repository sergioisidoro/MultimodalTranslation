function [ word ] = f_clean_up_english_verbs( word )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

word = regexprep(word, '__', '_');

if (strcmp(word, 'amble_') || strcmp(word, 'ambling_') || strcmp(word, 'ample_') )
    word = 'ambling_';
end
if (strcmp(word, 'hobble_') || strcmp(word, 'hobbling_'))
    word = 'hobble_';
end
if (strcmp(word, 'dancing?_') || strcmp(word, 'dancing_'))
    word = 'dancing_';
end
if (strcmp(word, 'edging_') || strcmp(word, 'edging_forward_'))
    word = 'edging_';
end
if (strcmp(word, 'limb_') || strcmp(word, 'limbing_') || strcmp(word, 'limb_')  || strcmp(word, 'limping_') || strcmp(word, 'limpping_') || strcmp(word, 'limpin_')  )
    word = 'limbing_';
end
if (strcmp(word, 'march_') || strcmp(word, 'marching_'))
    word = 'marching_';
end
if (strcmp(word, 'meander_') || strcmp(word, 'meandering_'))
    word = 'meander_';
end
if (strcmp(word, 'stagger_') || strcmp(word, 'staggering_'))
    word = 'staggering_';
end
if (strcmp(word, 'strut_') || strcmp(word, 'strutting_'))
    word = 'strutting_';
end
if (strcmp(word, 'trodding_') || strcmp(word, 'trot_'))
    word = 'trodding_';
end
if (strcmp(word, 'walk_') || strcmp(word, 'walking_') || strcmp(word, 'walkking_') || strcmp(word, 'wolking_') )
    word = 'walking_';
end

end

