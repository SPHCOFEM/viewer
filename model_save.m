fin = fopen([name, '.in'], 'w');

fprintf(fin, '$=========================$\n');
fprintf(fin, '$ sphcofem input database $\n');
fprintf(fin, '$=========================$\n');

if exist('name', 'var') && ~isempty(name)
    fprintf(fin, '$\n');
    fprintf(fin, '$ file name\n');
    fprintf(fin, '$----------\n');
    fprintf(fin, 'NAME %s\n', name);
end

if exist('dim', 'var') && ~isempty(dim)
   fprintf(fin, '$\n');
   fprintf(fin, '$ dimension\n');
   fprintf(fin, '$----------\n');
   fprintf(fin, 'DIM %d\n', dim);
end

if exist('tmax', 'var') && ~isempty(tmax)
   fprintf(fin, '$\n');
   fprintf(fin, '$ termination time\n');
   fprintf(fin, '$-----------------\n');
   fprintf(fin, 'TMAX %e\n', tmax);
end

if exist('time', 'var') && ~isempty(time)
   fprintf(fin, '$\n');
   fprintf(fin, '$ time controls - dtsave dinit dtmax cour kstab\n');
   fprintf(fin, '$----------------------------------------------\n');
   fprintf(fin, 'TIME %e %e %e %e %e\n', time);
end

if exist('gacc', 'var') && ~isempty(gacc)
   fprintf(fin, '$\n');
   fprintf(fin, '$ global acceleration field - ax ay az\n');
   fprintf(fin, '$-------------------------------------\n');
   fprintf(fin, 'GACC %e %e %e\n', gacc);
end

if exist('optim', 'var') && ~isempty(optim)
   fprintf(fin, '$\n');
   fprintf(fin, '$ optimization - dcheck dprint cprint nnopt opt ccont intscheme memcheck\n');
   fprintf(fin, '$-----------------------------------------------------------------------\n');
   fprintf(fin, 'OPTIM %d %d %d %d %e %d %d %d\n', optim);
end

if exist('sph', 'var') && ~isempty(sph)
   fprintf(fin, '$\n');
   fprintf(fin, '$ sph - visc alpha beta eta zeta nas theta ix xeps\n');
   fprintf(fin, '$-------------------------------------------------\n');
   fprintf(fin, 'SPH %d %e %e %e %e %e %e %d %e\n', sph);
end

if exist('fem', 'var') && ~isempty(fem)
   fprintf(fin, '$\n');
   fprintf(fin, '$ fem - c0 c1\n');
   fprintf(fin, '$------------\n');
   fprintf(fin, 'FEM %e %e\n', fem);
end

if exist('saver', 'var') && ~isempty(saver)
   fprintf(fin, '$\n');
   fprintf(fin, '$ save - dt kines innes potes kineb disib defob poteb tote vs dvs as fs rhos drhos us dus ps cs hs Ss dSs es des Os vb ab fb xr psir vr or ar alphar fr Mr Fc\n');
   fprintf(fin, '$------------------------------------------------------------------------------------------------------------------------------------------------------------\n');
   fprintf(fin, 'SAVE %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', saver);
end

if exist('funct', 'var') && ~isempty(funct)
   fprintf(fin, '$\n');
   fprintf(fin, '$ functions - num pairs mx my dx dy\n');
   fprintf(fin, '$             fxi fyi\n');
   fprintf(fin, '$----------------------------------\n');
   count = 1;
   while 1
      fprintf(fin, 'FUNCT %d %d %e %e %e %e\n', ...
              funct(count, :), funct(count + 1, :), funct(count + 2, :));
      for j = count + 3 : count + 2 + funct(count, 2)
          fprintf(fin, '      %e %e\n', funct(j, :));
      end
      if j == length(funct(:, 1))
          break;
      else
          count = j + 1;
      end
   end
end

if exist('mater', 'var') && ~isempty(mater)
   fprintf(fin, '$\n');
   fprintf(fin, '$ materials - num domain type rho mu T kappa gamma aux1 aux2 aux3 aux4\n');
   fprintf(fin, '$---------------------------------------------------------------------\n');
   for i = 1 : length(mater(:, 1))
      if mater(i, 3) == 0
         fprintf(fin, 'MATER %d %d %d %e %e %e %e %e %d %d %d %d\n', mater(i, :));
      else
         fprintf(fin, 'MATER %d %d %d %e %e %e %e %e %e %e %e %e\n', mater(i, :));
      end
   end
end

if exist('contact', 'var') && ~isempty(contact)
   fprintf(fin, '$\n');
   fprintf(fin, '$ contacts - num mats matb type ct klin knon kf kd\n');
   fprintf(fin, '$-------------------------------------------------\n');
   for i = 1 : length(contact(:, 1))
      fprintf(fin, 'CONTACT %d %d %d %d %e %e %e %e %e\n', contact(i, :));
   end
end

if exist('snode', 'var') && ~isempty(snode)
   fprintf(fin, '$\n');
   fprintf(fin, '$ domain nodes - num mat vol x y z\n');
   fprintf(fin, '$---------------------------------\n');
   for i = 1 : length(snode(:, 1))
      fprintf(fin, 'SNODE %d %d %e %e %e %e\n', snode(i, :));
   end
end

if exist('bnode', 'var') && ~isempty(bnode)
   fprintf(fin, '$\n');
   fprintf(fin, '$ boundary nodes - num x y z\n');
   fprintf(fin, '$---------------------------\n');
   for i = 1 : length(bnode(:, 1))
      fprintf(fin, 'BNODE %d %e %e %e\n', bnode(i, :));
   end
end

if exist('belem', 'var') && ~isempty(belem)
   fprintf(fin, '$\n');
   fprintf(fin, '$ boundary elements - num mat n1 n2 n3 n4\n');
   fprintf(fin, '$----------------------------------------\n');
   for i = 1 : length(belem(:, 1))
      fprintf(fin, 'BELEM %d %d %d %d %d %d\n', belem(i, 1 : 6));
   end
end

if exist('invel', 'var') && ~isempty(invel)
   fprintf(fin, '$\n');
   fprintf(fin, '$ initial velocities - num vx vy vz ox oy oz frame\n');
   fprintf(fin, '$-------------------------------------------------\n');
   for i = 1 : length(invel(:, 1))
      fprintf(fin, 'INVEL %d %e %e %e %e %e %e %d\n', invel(i, :));
   end
end

if exist('inpre', 'var') && ~isempty(inpre)
   fprintf(fin, '$\n');
   fprintf(fin, '$ initial pressures - num p\n');
   fprintf(fin, '$--------------------------\n');
   for i = 1 : length(inpre(:, 1))
      fprintf(fin, 'INPRE %d %e\n', inpre(i, :));
   end
end

if exist('acfld', 'var') && ~isempty(acfld)
   fprintf(fin, '$\n');
   fprintf(fin, '$ acceleration fields - num type ax ay az frame\n');
   fprintf(fin, '$----------------------------------------------\n');
   for i = 1 : length(acfld(:, 1))
      if acfld(i, 2) == 0
         fprintf(fin, 'ACFLD %d %d %e %e %e %d\n', acfld(i, :));
      else
         fprintf(fin, 'ACFLD %d %d %d %d %d\n', acfld(i, :));
      end
   end
end

if exist('force', 'var') && ~isempty(force)
   fprintf(fin, '$\n');
   fprintf(fin, '$ concentrated forces - num type fx fy fz mx my mz frame\n');
   fprintf(fin, '$-------------------------------------------------------\n');
   for i = 1 : length(force(:, 1))
      if force(i, 2) == 0
         fprintf(fin, 'FORCE %d %d %e %e %e %e %e %e %d\n', force(i, :));
      else
         fprintf(fin, 'FORCE %d %d %d %d %d %d %d %d %d\n', force(i, :));
      end
   end
end

if exist('ndamp', 'var') && ~isempty(dampi)
   fprintf(fin, '$\n');
   fprintf(fin, '$ dampings - num dx dy dz \n');
   fprintf(fin, '$-------------------------\n');
   for i = 1 : length(dampi(:, 1))
      fprintf(fin, 'NDAMP %d %e %e %e\n', dampi(i, :));
   end
end

if exist('bounc', 'var') && ~isempty(bounc)
   fprintf(fin, '$\n');
   fprintf(fin, '$ boundary conditions - num type bx by bz rx ry rz frame\n');
   fprintf(fin, '$-------------------------------------------------------\n');
   for i = 1 : length(bounc(:, 1))
      fprintf(fin, 'BOUNC %d %d %d %d %d %d %d %d %d\n', bounc(i, :));
   end
end

fclose(fin);
