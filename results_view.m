%% reading results
if ~exist('ie', 'var') % read model
    results_read
end

%% initialization
version = ver;
system = version.Name;
if ~exist('t', 'var')
    results_read
end

if ~exist('iw', 'var') % save movie
    iw = 0; % [0] no, [1] yes
end

if ~exist('ip', 'var') % draw particles
    ip = 1; % [0] contours, [1] particles, [2] with velocity
end

if ~exist('ib', 'var') % draw boundary elements
    ib = 1; % [0] nodes, [1] with elements, [2] with elements edges
end

if ~exist('ik', 'var') % draw particular particle
    ik = []; % index range
end

if ~exist('nt', 'var') % movie step
    nt = 1; % states between steps
end

if ~exist('id', 'var') || (exist('id', 'var') && id == 2) % movie composition
    subpos = [1, 2];
else
    subpos = [1, 1];
end

if strcmp(name(1 : 3), 'bul') % only for bullet
    is = find(ys(1, :) >= 0 & snode(:, 2)' == 1); % only bullet half
    bi = find(snode(:, 2) == 2 | snode(:, 2) == 3); % for bullet: solid material
elseif ~isempty(xs)
    is = 1 : length(xs(1, :));
end

% zero values in non-used dimension
switch dim
    case 1, ys = zeros(size(xs)); zs = zeros(size(xs));
            yb = zeros(size(xb)); zb = zeros(size(xb));
    case 2, zs = zeros(size(xs)); zb = zeros(size(xb));
end

%% main figure
hf = figure('Position', [50, 50, 1200, 600], 'Name', name);
%hf = figure('Position', [1, 10, 1600, 1000], 'Name', name);

%% plot options
if id == 1 % only variable
    plot(c1, c2), hold on, grid on
    plot(c1, mean(c2, 2), 'k-', 'LineWidth', 3)
    xlabel(c1val), ylabel(c2val), set(gca, 'FontSize', 16)
elseif id == 2 % synchronized movie
    subplot(subpos(1), subpos(2), 2), plot(c1, c2), hold on, grid on
    plot(c1, mean(c2, 2), 'k-', 'LineWidth', 3)
    xlabel(c1val), ylabel(c2val), set(gca, 'FontSize', 16)
    crange = get(gca, 'YLim');
end

if id == 0 || id == 2 % movie
    xmin = min(min([xs, xb])); xmax = max(max([xs, xb])); if xmin == xmax, xmax = xmin + 1; end
    ymin = min(min([ys, yb])); ymax = max(max([ys, yb])); if ymin == ymax, ymax = ymin + 1; end
    zmin = min(min([zs, zb])); zmax = max(max([zs, zb])); if zmin == zmax, zmax = zmin + 1; end

    subplot(subpos(1), subpos(2), 1), hold on, axis off, axis equal
    axis([xmin, xmax, ymin, ymax, zmin, zmax])
    xlabel('x [m]'), ylabel('y [m]'), zlabel('z [m]')
    set(gca, 'FontSize', 12)

    switch dim % simplified view in 1D or 2D
        case {1, 2}, view([0, 90])
        case 3, view([0, 0]) % view([45, 30])
    end

    if exist('iv', 'var') % pre-defined view
        view(iv)
    else
        %view([0, 0])
        %view([45, 30])
        %view([-90,0])
        view([-45, 30])
    end
    
    if ~exist('c1', 'var') % abscissa not pre-defined -> time t
        c1val = 't';
        c1 = t;
    end
    if ~exist('c2', 'var') % ordinate not pre-defined -> time t
        if ~isempty(xs)
            %c2val = 'Velocity resultant';
            %c2 = sqrt(vxs .^ 2 + vys .^ 2);
            c2val = 'Pressure';
            c2 = ps;
            %exx = es(:, 1 : n_s); Sxx = Ss(:, 1 : n_s);
            %exy = es(:, n_s + 1 : 2 * n_s); Sxy = Ss(:, n_s + 1 : 2 * n_s);
            %exz = es(:, 2 * n_s + 1 : 3 * n_s); Sxz = Ss(:, 2 * n_s + 1 : 3 * n_s);
            %eyy = es(:, 3 * n_s + 1 : 4 * n_s); Syy = Ss(:, 3 * n_s + 1 : 4 * n_s);
            %eyz = es(:, 4 * n_s + 1 : 5 * n_s); Syz = Ss(:, 4 * n_s + 1 : 5 * n_s);
            %ezz = es(:, 5 * n_s + 1 : 6 * n_s); Szz = Ss(:, 5 * n_s + 1 : 6 * n_s);
        else
            c2val = '';
            c2 = zeros(size(1 : nt : length(t)))';
        end
    end

    % min and max values
    cmin = min(min(c2)); cmax = max(max(c2));
    if cmin == cmax
        cmax = cmin + 1;
    end
    cmint = cmin; cmaxt = cmax;
    colorbar, caxis([cmin, cmax])

    %% create colorbar
    map = colormap; [m, n] = size(map);
    index = round((m - 1) * c2 / (cmax - cmin) + 1 - (m - 1) * cmin / (cmax - cmin));
    clr = zeros(length(t), n_s, n);
    for i = 1 : length(t)
        for j = 1 : n_s
            clr(i, j, :) = map(index(i, j), :);
        end
    end

    % set movie
    if iw
        M = VideoWriter([name, '.avi']); %#ok<UNRCH>
        M.FrameRate = 5;
        open(M);
    end
    disp('Making movie ...')

    % for all states
    cmin = zeros(1, length(t));
    cmax = zeros(1, length(t));
    for i = 1 : nt : length(t)

        if exist('bele', 'var') && ~isempty(bele)
            % draw boundary nodes
            subplot(subpos(1), subpos(2), 1)
            plot3(xb(i, :), yb(i, :), zb(i, :), 'ko')

            % draw bounary elements
            if exist('ib', 'var') && ib
                subplot(subpos(1), subpos(2), 1)
                for j = 1 : n_e 
                    n1 = bele(j, 1) + 1; n2 = bele(j, 2) + 1;
                    n3 = bele(j, 3) + 1; n4 = bele(j, 4) + 1;
                    if strcmp(system, 'Octave')
                        hi(1) = fill([xb(i, n1), xb(i, n2), xb(i,n3)], [yb(i, n1), yb(i, n2), yb(i, n3)], [zb(i, n1), zb(i, n2), zb(i, n3)], 'g');
                        hi(2) = fill([xb(i, n1), xb(i, n2), xb(i,n4)], [yb(i, n1), yb(i, n2), yb(i, n4)], [zb(i, n1), zb(i, n2), zb(i, n4)], 'g');
                        hi(3) = fill([xb(i, n2), xb(i, n3), xb(i,n4)], [yb(i, n2), yb(i, n3), yb(i, n4)], [zb(i, n2), zb(i, n3), zb(i, n4)], 'g');
                        hi(4) = fill([xb(i, n1), xb(i, n3), xb(i,n4)], [yb(i, n1), yb(i, n3), yb(i, n4)], [zb(i, n1), zb(i, n3), zb(i, n4)], 'g');
                    else
                        hi(1) = fill3([xb(i, n1), xb(i, n2), xb(i,n3)], [yb(i, n1), yb(i, n2), yb(i, n3)], [zb(i, n1), zb(i, n2), zb(i, n3)], 'g');
                        hi(2) = fill3([xb(i, n1), xb(i, n2), xb(i,n4)], [yb(i, n1), yb(i, n2), yb(i, n4)], [zb(i, n1), zb(i, n2), zb(i, n4)], 'g');
                        hi(3) = fill3([xb(i, n2), xb(i, n3), xb(i,n4)], [yb(i, n2), yb(i, n3), yb(i, n4)], [zb(i, n2), zb(i, n3), zb(i, n4)], 'g');
                        hi(4) = fill3([xb(i, n1), xb(i, n3), xb(i,n4)], [yb(i, n1), yb(i, n3), yb(i, n4)], [zb(i, n1), zb(i, n3), zb(i, n4)], 'g');
                        %if j <=2, set(hi, 'facealpha', 0.1); end
                        %set(hi,'EdgeColor','None')
                        set(hi, 'facealpha', 0.1)
                        if dim > 2 && ib < 2, set(hi, 'EdgeColor', 'None'), end
                    end
                end
            end
        end

        % draw fluid
        if ~isempty(xs)
            if ip > 0 || dim == 2 % draw particles & vector field
                subplot(subpos(1), subpos(2), 1)
                scatter3(xs(i, is), ys(i, is), zs(i, is), 100, squeeze(clr(i, is, :)));
                if strcmp(name(1 : 3), 'bul') % only for bullet
                    subplot(subpos(1), subpos(2), 1)
                    plot3(xs(i, bi), ys(i, bi), zs(i, bi), 'k*');
                end
                if ip == 2 && dim == 2
                    subplot(subpos(1), subpos(2), 1)
                    quiver(xs(i, :) ,ys(i, :), vxs(i, :), vys(i, :))
                end
            else % draw contours
                shp = alphaShape(xs(i, :)', ys(i, :)', 2); %bf = boundaryFacets(shp);
                tri = alphaTriangulation(shp);
                subplot(subpos(1), subpos(2), 1)
                tricontf(xs(i, :)', ys(i, :)', tri, c2(i, :)');
            end

            % draw particular particle
            subplot(subpos(1), subpos(2), 1)
            %plot3(xs(i, ik), ys(i, ik), zs(i, ik), 'ko', 'LineWidth', 10)
            plot3(xs(i, ik), ys(i, ik), zs(i, ik), 'r.', 'LineWidth', 10)
        end

        % draw boundary lines
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lb1), ys(i, lb1), zs(i, lb1), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lb2), ys(i, lb2), zs(i, lb2), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lm1), ys(i, lm1), zs(i, lm1), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lm2), ys(i, lm2), zs(i, lm2), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lm3), ys(i, lm3), zs(i, lm3), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lt1), ys(i, lt1), zs(i, lt1), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lt2), ys(i, lt2), zs(i, lt2), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lr1), ys(i, lr1), zs(i, lr1), 'k-')
        %subplot(subpos(1), subpos(2), 1), plot3(xs(i, lr2), ys(i, lr2), zs(i, lr2), 'k-')

        cmin(i) = min(c2(i, :));
        cmax(i) = max(c2(i, :));
        subplot(subpos(1), subpos(2), 1)
        title(['# ', num2str(i), ' / ', num2str(length(t)), ': ', ...
               c2val, ' (t = ', num2str(t(i)), ') \in [', num2str(round(cmin(i), 2)), ...
                    ', ', num2str(round(cmax(i), 2)), ']'])
        if id == 2
            subplot(subpos(1), subpos(2), 2)
            hps = plot([c1(i), c1(i)], [crange(1), crange(2)], 'k--', 'LineWidth', 2);
        end

        % draw state
        drawnow, if iw, writeVideo(M, getframe(hf)); end %#ok<UNRCH>
        
        % save chosen states as figures
        %if i == 1 || i == length(t)
        %    str = num2str(i);
        %    saveas(gcf, [name, '_', repmat('0', 1, 3 - length(str)), str], 'png')
        %end
        
        % prepare for new state
        if i < length(t)
            subplot(subpos(1), subpos(2), 1), delete(get(gca, 'Children'))        
            if exist('hps', 'var')
                delete(hps)
            end
        end
    end
end

if iw, close(M); end %#ok<UNRCH>
disp('... done.')
