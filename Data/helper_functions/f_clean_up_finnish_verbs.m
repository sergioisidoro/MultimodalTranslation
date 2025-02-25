function [ word ] = f_clean_up_finnish_verbs( word )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

word = regexprep(word, '__', '_');

if (strcmp(word, 'harppoa_') || strcmp(word, 'harppoo_'))
    word = 'harppoo_';
end
if (strcmp(word, 'hiipii_') || strcmp(word, 'hiipiä_'))
    word = 'hiipii_';
end
if (strcmp(word, 'hölkkäilee_') || strcmp(word, 'hölkkäillä_'))
    word = 'hölkkäilee_';
end
if (strcmp(word, 'hölkkää_') || strcmp(word, 'hölkätä_'))
    word = 'hölkkää_';
end
if (strcmp(word, 'juoksee_') || strcmp(word, 'juosta_'))
    word = 'juoksee_';
end
if (strcmp(word, 'kävelee_') || strcmp(word, 'kävellä_'))
    word = 'kävelee_';
end
if (strcmp(word, 'linkkaa_') || strcmp(word, 'linkata_'))
    word = 'linkkaa_';
end
if (strcmp(word, 'lönköttelee_') || strcmp(word, 'lönkötellä_'))
    word = 'lönköttelee_';
end
if (strcmp(word, 'löntystelee_') || strcmp(word, 'löntystellä_'))
    word = 'löntystelee_';
end
if (strcmp(word, 'marssii_') || strcmp(word, 'marssia_'))
    word = 'marssii_';
end
if (strcmp(word, 'ontuu_') || strcmp(word, 'ontua_'))
    word = 'ontuu_';
end

end

