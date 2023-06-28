%% open file
disp('Reading results ...')
file = fopen([name, '.out'], 'r');
ie = 1; % model exist (0/1)

%% read header
dim = fread(file, 1, 'integer*4');
ix = fread(file, 1, 'integer*4');

n_m = fread(file, 1, 'integer*4');
n_s = fread(file, 1, 'integer*4');
n_b = fread(file, 1, 'integer*4');
n_e = fread(file, 1, 'integer*4');
n_r = fread(file, 1, 'integer*4');
n_c = fread(file, 1, 'integer*4');
   
num_m = fread(file, [1, n_m], 'integer*4');
num_s = fread(file, [1, n_s], 'integer*4');
num_b = fread(file, [1, n_b], 'integer*4');
num_e = fread(file, [1, n_e], 'integer*4');

mat_s = fread(file, [1, n_s], 'integer*4');
mat_e = fread(file, [1, n_e], 'integer*4');
   
bele = fread(file, [n_e, 4], 'integer*4');

saver = fread(file, [1, 37], 'integer*4');

%% read sequences
t = [];
xs = []; ys = []; zs = [];
xb = []; yb = []; zb = [];

if saver(1), dt = []; end
if saver(2), kine_s = []; end
if saver(3), inne_s = []; end
if saver(4), pote_s = []; end
if saver(5), kine_b = []; end
if saver(6), defo_b = []; end
if saver(7), pote_b = []; end
if saver(8), disi_b = []; end
if saver(9), tote = []; end
if saver(10), vxs = []; vys = []; vzs = []; end
if saver(11) && ix, dvxs = []; dvys = []; dvzs = []; end
if saver(12), axs = []; ays = []; azs = []; end
if saver(13), fxs = []; fys = []; fzs = []; end
if saver(14), rhos = []; end
if saver(15), drhos = []; end
if saver(16), us = []; end
if saver(17), dus = []; end
if saver(18), ps = []; end
if saver(19), cs = []; end
if saver(20), hs = []; end
if saver(21), es = []; end
if saver(22), des = []; end
if saver(23) && dim > 1, Os = []; end
if saver(24) && dim > 1, Ss = []; end
if saver(25) && dim > 1, dSs = []; end
if saver(26), vxb = []; vyb = []; vzb = []; end
if saver(27), axb = []; ayb = []; azb = []; end
if saver(28), fxb = []; fyb = []; fzb = []; end

if saver(29)
    xr = [];
    if dim > 1, yr = []; end
    if dim > 2, zr = []; end
end
if saver(30)
    if dim > 1, psixr = []; end
    if dim > 2, psiyr = []; psizr = []; end
end
if saver(31)
    vxr = [];
    if dim > 1, vyr = []; end
    if dim > 2, vzr = []; end
end
if saver(32)
    if dim > 1, oxr = []; end
    if dim > 2, oyr = []; ozr = []; end
end
if saver(33)
    axr = [];
    if dim > 1, ayr = []; end
    if dim > 2, azr = []; end
end
if saver(34)
    if dim > 1, alphaxr = []; end 
    if dim > 2, alphayr = []; alphazr = []; end
end
if saver(35)
    fxr = [];
    if dim > 1, fyr = []; end
    if dim > 2, fzr = []; end
end
if saver(36)
    if dim > 1, Mxr = []; end 
    if dim > 2, Myr = []; Mzr = []; end
end

if saver(37), fxc = []; fyc = []; fzc = []; end

while ~feof(file)
    t = [t; fread(file, 1, 'real*8')]; %#ok<*AGROW>
    if saver(1), dt = [dt; fread(file, 1, 'real*8')]; end
    
    if n_s > 0
        if saver(2), kine_s = [kine_s; fread(file, 1, 'real*8')]; end
        if saver(3), inne_s = [inne_s; fread(file, 1, 'real*8')]; end
        if saver(4), pote_s = [pote_s; fread(file, 1, 'real*8')]; end
    end
    
    if n_b > 0
        if saver(5), kine_b = [kine_b; fread(file, 1, 'real*8')]; end
        if saver(6), disi_b = [disi_b; fread(file, 1, 'real*8')]; end
        if saver(7), defo_b = [defo_b; fread(file, 1, 'real*8')]; end
        if saver(8), pote_b = [pote_b; fread(file, 1, 'real*8')]; end
    end
    
    if saver(9), tote = [tote; fread(file, 1, 'real*8')]; end
    
    if n_s > 0
        xs = [xs; fread(file, [1, n_s], 'real*8')];
        if dim > 1, ys = [ys; fread(file, [1, n_s], 'real*8')]; end
        if dim > 2, zs = [zs; fread(file, [1, n_s], 'real*8')]; end
        
        if saver(10)
            vxs = [vxs; fread(file, [1, n_s], 'real*8')];
            if dim > 1, vys = [vys; fread(file, [1, n_s], 'real*8')]; end
            if dim > 2, vzs = [vzs; fread(file, [1, n_s], 'real*8')]; end
        end
        
        if saver(11) && ix
            dvxs = [dvxs; fread(file, [1, n_s], 'real*8')];
            if dim > 1, dvys = [dvys; fread(file, [1, n_s], 'real*8')]; end
            if dim > 2, dvzs = [dvzs; fread(file, [1, n_s], 'real*8')]; end
        end
        
        if saver(12)
            axs = [axs; fread(file, [1, n_s], 'real*8')];
            if dim > 1, ays = [ays; fread(file, [1, n_s], 'real*8')]; end
            if dim > 2, azs = [azs; fread(file, [1, n_s], 'real*8')]; end
        end
        
        if saver(13)
            fxs = [fxs; fread(file, [1, n_s], 'real*8')];
            if dim > 1, fys = [fys; fread(file, [1, n_s], 'real*8')]; end
            if dim > 2, fzs = [fzs; fread(file, [1, n_s], 'real*8')]; end
        end
        
        if saver(14), rhos = [rhos; fread(file, [1, n_s], 'real*8')]; end
        if saver(15), drhos = [drhos; fread(file, [1, n_s], 'real*8')]; end
        if saver(16), us = [us; fread(file, [1, n_s], 'real*8')]; end
        if saver(17), dus = [dus; fread(file, [1, n_s], 'real*8')]; end
        
        if saver(18), ps = [ps; fread(file, [1, n_s], 'real*8')]; end
        if saver(19), cs = [cs; fread(file, [1, n_s], 'real*8')]; end
        if saver(20), hs = [hs; fread(file, [1, n_s], 'real*8')]; end
        
        switch dim
            case 1, se = 1; %se = 6; so = 6; ss = 6;
            case 2, se = 3; so = 1; ss = 3; %se = 6; so = 6; ss = 6;
            case 3, se = 6; so = 3; ss = 6; %se = 6; so = 6; ss = 6;
        end
        
        if saver(21), es = [es; fread(file, [1, se * n_s], 'real*8')]; end
        if saver(22), des = [des; fread(file, [1, se * n_s], 'real*8')]; end
        if saver(23) && dim > 1, Os = [Os; fread(file, [1, so * n_s], 'real*8')]; end
        if saver(24) && dim > 1, Ss = [Ss; fread(file, [1, ss * n_s], 'real*8')]; end
        if saver(25) && dim > 1, dSs = [dSs; fread(file, [1, ss * n_s], 'real*8')]; end
    end
    
    if n_b > 0
        xb = [xb; fread(file, [1, n_b], 'real*8')];
        if dim > 1, yb = [yb; fread(file, [1, n_b], 'real*8')]; end
        if dim > 2, zb = [zb; fread(file, [1, n_b], 'real*8')]; end
        
        if saver(26)
            vxb = [vxb; fread(file, [1, n_b], 'real*8')];
            if dim > 1, vyb = [vyb; fread(file, [1, n_b], 'real*8')]; end
            if dim > 2, vzb = [vzb; fread(file, [1, n_b], 'real*8')]; end
        end
        
        if saver(27)
            axb = [axb; fread(file, [1, n_b], 'real*8')];
            if dim > 1, ayb = [ayb; fread(file, [1, n_b], 'real*8')]; end
            if dim > 2, azb = [azb; fread(file, [1, n_b], 'real*8')]; end
        end
        
        if saver(28)
            fxb = [fxb; fread(file, [1, n_b], 'real*8')];
            if dim > 1, fyb = [fyb; fread(file, [1, n_b], 'real*8')]; end
            if dim > 2, fzb = [fzb; fread(file, [1, n_b], 'real*8')]; end
        end
    end
    
    if n_r > 0
        if saver(29)
            xr = [xr; fread(file, [1, n_r], 'real*8')];
            if dim > 1, yr = [yr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2, zr = [zr; fread(file, [1, n_r], 'real*8')]; end
        end
        
        if saver(30)
            if dim > 1, psixr = [psixr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2
                psiyr = [psiyr; fread(file, [1, n_r], 'real*8')];
                psizr = [psizr; fread(file, [1, n_r], 'real*8')];
            end
        end
        
        if saver(31)
            vxr = [vxr; fread(file, [1, n_r], 'real*8')];
            if dim > 1, vyr = [vyr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2, vzr = [vzr; fread(file, [1, n_r], 'real*8')]; end
        end
        
        if saver(32)
            i = i + 1;
            if dim > 1, oxr = [oxr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2
                i = i + 1; oyr = [oyr; fread(file, [1, n_r], 'real*8')];
                i = i + 1; ozr = [ozr; fread(file, [1, n_r], 'real*8')];
            end
        end
        
        if saver(33)
            axr = [axr; fread(file, [1, n_r], 'real*8')];
            if dim > 1, ayr = [ayr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2, azr = [azr; fread(file, [1, n_r], 'real*8')]; end
        end
        
        if saver(34)
            if dim > 1, alphaxr = [alphaxr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2
                alphayr = [alphayr; fread(file, [1, n_r], 'real*8')];
                alphazr = [alphazr; fread(file, [1, n_r], 'real*8')];
            end
        end
        
        if saver(35)
            fxr = [fxr; fread(file, [1, n_r], 'real*8')];
            if dim > 1, fyr = [fyr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2, fzr = [fzr; fread(file, [1, n_r], 'real*8')]; end
        end
        
        if saver(36)
            if dim > 1, Mxr = [Mxr; fread(file, [1, n_r], 'real*8')]; end
            if dim > 2
                Myr = [Myr; fread(file, [1, n_r], 'real*8')];
                Mzr = [Mzr; fread(file, [1, n_r], 'real*8')];
            end
        end
    end
    
    if n_c > 0
        if saver(37)
            fxc = [fxc; fread(file, [1, n_c], 'real*8')];
            if dim > 1, fyc = [fyc; fread(file, [1, n_c], 'real*8')]; end
            if dim > 2, fzc = [fzc; fread(file, [1, n_c], 'real*8')]; end
        end
    end
end

fclose(file);
disp('... done.')
