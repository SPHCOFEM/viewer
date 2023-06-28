%% axis range
if exist('snode', 'var') && exist('bnode', 'var') && isempty(bnode) && isempty(snode)
    xmin = 0;
    xmax = 0;
    ymin = 0;
    ymax = 0;
    zmin = 0;
    zmax = 0;
elseif exist('snode', 'var') && ~isempty(snode) && (~exist('bnode', 'var') || isempty(bnode))
    xmin = min(min(snode(:, 4)));
    xmax = max(max(snode(:, 4)));
    ymin = min(min(snode(:, 5)));
    ymax = max(max(snode(:, 5)));
    zmin = min(min(snode(:, 6)));
    zmax = max(max(snode(:, 6)));
elseif exist('bnode', 'var') && ~isempty(bnode) && (~exist('snode', 'var') || isempty(snode))
    xmin = min(min(bnode(:, 2)));
    xmax = max(max(bnode(:, 2)));
    ymin = min(min(bnode(:, 3)));
    ymax = max(max(bnode(:, 3)));
    zmin = min(min(bnode(:, 4)));
    zmax = max(max(bnode(:, 4)));
else % exist('bnode', 'var') && ~isempty(bnode) && (exist('snode', 'var') && ~isempty(snode))
    xmin = min([min(min(snode(:, 4))), min(min(bnode(:, 2)))]);
    xmax = max([max(max(snode(:, 4))), max(max(bnode(:, 2)))]);
    ymin = min([min(min(snode(:, 5))), min(min(bnode(:, 3)))]);
    ymax = max([max(max(snode(:, 5))), max(max(bnode(:, 3)))]);
    zmin = min([min(min(snode(:, 6))), min(min(bnode(:, 4)))]);
    zmax = max([max(max(snode(:, 6))), max(max(bnode(:, 4)))]);
end

xmin = xmin - (xmax - xmin) / 100;
xmax = xmax + (xmax - xmin) / 100;
ymin = ymin - (ymax - ymin) / 100;
ymax = ymax + (ymax - ymin) / 100;
zmin = zmin - (zmax - zmin) / 100;
zmax = zmax + (zmax - zmin) / 100;

if xmin == xmax
    xmin = xmin - 1e-9;
    xmax = xmax + 1e-9;
end

if ymin == ymax
    ymin = ymin - 1e-9;
    ymax = ymax + 1e-9;
end

if zmin == zmax
    zmin = zmin - 1e-9;
    zmax = zmax + 1e-9;
end

figure, hold on, axis equal
axis([xmin, xmax, ymin, ymax, zmin, zmax])
hold on

%% snode
if exist('snode', 'var') && ~isempty(snode)
    hp = plot3(snode(:, 4), snode(:, 5), snode(:, 6), 'bo');
    bi = find(snode(:, 2) == 2 | snode(:, 2) == 3); % for bullet: solid material
    plot3(snode(bi, 4), snode(bi, 5), snode(bi, 6), 'k*');
    set(hp, 'Color', [91 / 255, 155 / 255, 213 / 255])
end

%% bnode
if exist('bnode', 'var') && ~isempty(bnode)
   plot3(bnode(:, 2), bnode(:, 3), bnode(:, 4), 'ko')
end

%% belem
if exist('belem', 'var') && ~isempty(belem) && ~isempty(bnode)
    for i = 1 : length(belem(:, 1))
        i1 = find(bnode(:, 1) == belem(i, 3));
        i2 = find(bnode(:, 1) == belem(i, 4));
        i3 = find(bnode(:, 1) == belem(i, 5));
        i4 = find(bnode(:, 1) == belem(i, 6));
        h = fill3([bnode(i1, 2), bnode(i2, 2), bnode(i3, 2), bnode(i4, 2)], ...
                  [bnode(i1, 3), bnode(i2, 3), bnode(i3, 3), bnode(i4, 3)], ...
                  [bnode(i1, 4), bnode(i2, 4), bnode(i3, 4), bnode(i4, 4)], 'g');
        set(h, 'facealpha', 0.2)
        %if dim > 2
        %    set(h,'EdgeColor','None')
        %end
    end
end

%% simplified view in 1D or 2D
switch dim
    case {1, 2}, view([0, 90])
    case 3, view([-45, 30])
end
axis equal
xlabel('x [m]'), ylabel('y [m]'), zlabel('z [m]')
ht = title('Initial state');
set(gcf, 'Name', name)
