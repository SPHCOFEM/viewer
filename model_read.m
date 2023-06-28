fin = fopen(name, 'r');

funct = [];
mater = [];
contact = [];
snode = [];
bnode = [];
belem = [];
invel = [];
inpre = [];
acfld = [];
force = [];
ndamp = [];
bounc = [];

while ~feof(fin)
    
    line = fgets(fin);

    if length(line) > 4 && strcmp(line(1 : 4), 'NAME'), name = line(6 : end - 1); end
    if length(line) > 3 && strcmp(line(1 : 3), 'DIM'), dim = str2double(line(5 : end - 1)); end
    if length(line) > 4 && strcmp(line(1 : 4), 'TMAX'), tmax = str2double(line(6 : end - 1)); end
    if length(line) > 4 && strcmp(line(1 : 4), 'TIME'), time = str2num(line(6 : end - 1)); end %#ok<*ST2NM>
    if length(line) > 4 && strcmp(line(1 : 4), 'GACC'), gacc = str2num(line(6 : end - 1)); end %#ok<*ST2NM>
    if length(line) > 5 && strcmp(line(1 : 5), 'OPTIM'), optim = str2num(line(7 : end - 1)); end
    if length(line) > 3 && strcmp(line(1 : 3), 'SPH'), sph = str2num(line(5 : end - 1)); end
    if length(line) > 3 && strcmp(line(1 : 3), 'FEM'), fem = str2num(line(5 : end - 1)); end
    if length(line) > 4 && strcmp(line(1 : 4), 'SAVE'), saver = str2num(line(6 : end - 1)); end

    if length(line) > 5 && strcmp(line(1 : 5), 'FUNCT')
        funline = str2num(line(7 : end - 1));
        funct = [funct; funline(1 : 2); funline(3 : 4)]; %#ok<*AGROW>
        for i = 1 : funline(2)
            line = fgets(fin);
            funct = [funct; str2num(line(1 : end - 1))];
        end
    end
    
    if length(line) > 5 && strcmp(line(1 : 5), 'MATER'), mater = [mater; str2num(line(7 : end - 1))]; end
    if length(line) > 7 && strcmp(line(1 : 7), 'CONTACT'), contact = [contact; str2num(line(9 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'SNODE'), snode = [snode; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'BNODE'), bnode = [bnode; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'BELEM'), belem = [belem; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'INVEL'), invel = [invel; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'INPRE'), inpre = [inpre; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'ACFLD'), acfld = [acfld; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'FORCE'), force = [force; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'NDAMP'), ndamp = [ndamp; str2num(line(7 : end - 1))]; end
    if length(line) > 5 && strcmp(line(1 : 5), 'BOUNC'), bounc = [bounc; str2num(line(7 : end - 1))]; end

end

fclose(fin);

if isempty(funct), clear funct, end
if isempty(mater), clear mater, end
if isempty(contact), clear contact, end
if isempty(snode), clear snode, end
if isempty(bnode), clear bnode, end
if isempty(belem), clear belem, end
if isempty(invel), clear invel, end
if isempty(inpre), clear inpre, end
if isempty(acfld), clear acfld, end
if isempty(force), clear force, end
if isempty(ndamp), clear ndamp, end
if isempty(bounc), clear bounc, end
