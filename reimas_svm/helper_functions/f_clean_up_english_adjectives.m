function [ word ] = f_clean_up_english_adjectives( word )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Klaus Förger, Department of Media Technology, Aalto University, 2013 

word = regexprep(word, '__', '_');
word = regexprep(word, 'hyvin_', '');
word = regexprep(word, 'vähän_', '');
word = regexprep(word, 'hieman_', '');
word = regexprep(word, 'hiukan_', '');
word = regexprep(word, 'suhteellisen_', '');
word = regexprep(word, 'melko_', '');
word = regexprep(word, 'aika_', '');
word = regexprep(word, 'erittäin_', '');
word = regexprep(word, 'lievästi_', '');
word = regexprep(word, 'tosi_', '');


if (strcmp(word, 'aggressiivisesti_') || strcmp(word, 'aggressiivinen_'))
    word = 'aggressiivisesti_';
end
if (strcmp(word, 'empien_') || strcmp(word, 'empivä_'))
    word = 'empien_';
end
if (strcmp(word, 'energisesti_') || strcmp(word, 'energinen_'))
    word = 'energisesti_';
end
if (strcmp(word, 'harkitsevasti_') || strcmp(word, 'harkiten_'))
    word = 'harkitsevasti_';
end
if (strcmp(word, 'hitaasti_') || strcmp(word, 'hidas_'))
    word = 'hitaasti_';
end
if (strcmp(word, 'huolestuneesti_') || strcmp(word, 'huoleton_'))
    word = 'huolestuneesti_';
end
if (strcmp(word, 'iloisesti_') || strcmp(word, 'iloinen_'))
    word = 'iloisesti_';
end
if (strcmp(word, 'itsevarmasti_') || strcmp(word, 'itsevarma_'))
    word = 'itsevarmasti_';
end
if (strcmp(word, 'jäykästi_') || strcmp(word, 'jäykkä_'))
    word = 'jäykästi_';
end
if (strcmp(word, 'kiirehtien_') || strcmp(word, 'kiireinen_') || strcmp(word, 'kiireisesti_'))
    word = 'kiirehtien_';
end
if (strcmp(word, 'kivuliaasti_') || strcmp(word, 'kivulias_'))
    word = 'kivuliaasti_';
end
if (strcmp(word, 'laiskasti_') || strcmp(word, 'laiska_'))
    word = 'laiskasti_';
end
if (strcmp(word, 'masentuneesti_') || strcmp(word, 'masentunut_'))
    word = 'masentuneesti_';
end
if (strcmp(word, 'mietteliäästi_') || strcmp(word, 'mietteliäs_'))
    word = 'mietteliäästi_';
end
if (strcmp(word, 'määrätietoisesti_') || strcmp(word, 'määrätietoinen_'))
    word = 'määrätietoisesti_';
end
if (strcmp(word, 'nopeasti_') || strcmp(word, 'nopea_'))
    word = 'nopeasti_';
end
if (strcmp(word, 'normaalisti_') || strcmp(word, 'normaali_'))
    word = 'normaalisti_';
end
if (strcmp(word, 'ontuvasti_') || strcmp(word, 'ontuva_') || strcmp(word, 'ontuen_'))
    word = 'ontuvasti_';
end
if (strcmp(word, 'oudosti_') || strcmp(word, 'outo_'))
    word = 'oudosti_';
end
if (strcmp(word, 'pohdiskelevasti_') || strcmp(word, 'pohdiskeleva_'))
    word = 'pohdiskelevasti_';
end
if (strcmp(word, 'pohtivasti_') || strcmp(word, 'pohtiva_'))
    word = 'pohtivasti_';
end
if (strcmp(word, 'päättäväisesti_') || strcmp(word, 'päättäväinen_'))
    word = 'päättäväisesti_';
end
if (strcmp(word, 'raahautuvasti_') || strcmp(word, 'raahautuen_'))
    word = 'raahautuvasti_';
end
if (strcmp(word, 'rauhallisesti_') || strcmp(word, 'rauhallinen_'))
    word = 'rauhallisesti_';
end
if (strcmp(word, 'reippaasti_') || strcmp(word, 'reipas_'))
    word = 'reippaasti_';
end
if (strcmp(word, 'rennosti_') || strcmp(word, 'rento_'))
    word = 'rennosti_';
end
if (strcmp(word, 'ripeästi_') || strcmp(word, 'ripeä_'))
    word = 'ripeästi_';
end
if (strcmp(word, 'rohkeasti_') || strcmp(word, 'rohkea_'))
    word = 'rohkeasti_';
end
if (strcmp(word, 'rytmikkäästi_') || strcmp(word, 'rytmikäs_'))
    word = 'rytmikkäästi_';
end
if (strcmp(word, 'surullisesti_') || strcmp(word, 'surullinen_') || strcmp(word, 'surullisena_'))
    word = 'surullisesti_';
end
if (strcmp(word, 'surumielisesti_') || strcmp(word, 'surumielinen_'))
    word = 'surumielisesti_';
end
if (strcmp(word, 'tahdikkaasti_') || strcmp(word, 'tahdikas_'))
    word = 'tahdikkaasti_';
end
if (strcmp(word, 'takakenoisesti_') || strcmp(word, 'takakenoinen_'))
    word = 'takakenoisesti_';
end
if (strcmp(word, 'tarmokkaasti_') || strcmp(word, 'tarmokas_'))
    word = 'tarmokkaasti_';
end
if (strcmp(word, 'teennäisesti_') || strcmp(word, 'teennäinen_'))
    word = 'teennäisesti_';
end
if (strcmp(word, 'toispuoleisesti_') || strcmp(word, 'toispuoleinen_'))
    word = 'toispuoleisesti_';
end
if (strcmp(word, 'vaivaisesti_') || strcmp(word, 'vaivainen_'))
    word = 'vaivaisesti_';
end
if (strcmp(word, 'vaivalloisesti_') || strcmp(word, 'vaivalloinen_'))
    word = 'vaivalloisesti_';
end
if (strcmp(word, 'varautuneesti_') || strcmp(word, 'vammautunut_'))
    word = 'varautuneesti_';
end
if (strcmp(word, 'varovasti_') || strcmp(word, 'varoen_'))
    word = 'varovasti_';
end
if (strcmp(word, 'varovaisesti_') || strcmp(word, 'varovainen_'))
    word = 'varovaisesti_';
end
if (strcmp(word, 'verkkaisesti_') || strcmp(word, 'verkkainen_'))
    word = 'verkkaisesti_';
end
if (strcmp(word, 'vihaisesti_') || strcmp(word, 'vihainen_'))
    word = 'vihaisesti_';
end

end

