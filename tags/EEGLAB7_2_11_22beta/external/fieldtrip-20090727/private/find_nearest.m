function [nearest, distance] = find_nearest(pnt1, pnt2, npart);

% FIND_NEAREST finds the nearest vertex in a cloud of points and
% does this efficiently for many target vertices at once (by means
% of partitioning).
%
% Use as
%   [nearest, distance] = find_nearest(pnt1, pnt2, npart)

% Copyright (C) 2007, Robert Oostenveld
%
% $Log: not supported by cvs2svn $
% Revision 1.2  2007/02/08 14:43:14  roboos
% handle case when points ly in an empty target partition (required for cortex in 3d volume)
%
% Revision 1.1  2007/02/07 07:38:34  roboos
% new implementation, based on an idea of Theo
%

global fb;
if isempty(fb)
  fb = 0;
end

npnt1 = size(pnt1,1);
npnt2 = size(pnt2,1);

if all(pnt2(1,:)==1)
  % it might be gridded, test in more detail
  dim = max(pnt2);
  [X, Y, Z] = ndgrid(1:dim(1), 1:dim(2), 1:dim(3));
  if all(pnt2==[X(:) Y(:) Z(:)])
    % it is gridded, that can be treated much faster
    if fb, fprintf('pnt2 is gridded\n'); end
    sub = round(pnt1);
    sub(sub(:)<1) = 1;
    sub(sub(:,1)>dim(1),1) = dim(1);
    sub(sub(:,2)>dim(2),2) = dim(2);
    sub(sub(:,3)>dim(3),3) = dim(3);
    ind = sub2ind(dim, sub(:,1), sub(:,2), sub(:,3));
    nearest = ind(:);
    distance = sqrt(sum((pnt1-pnt2(ind,:)).^2, 2));
    return
  end
end

if npart<1
  npart = 1;
end

nearest  = ones(size(pnt1,1),1) * -1;
distance = ones(size(pnt1,1),1) * inf;
sel = find(nearest<0);

while ~isempty(sel)
  if fb, fprintf('nsel = %d, npart = %d\n', length(sel), npart); end
  [pnear, pdist] = find_nearest_partition(pnt1(sel,:), pnt2, npart);
  better = pdist<=distance(sel);
  nearest(sel(better)) = pnear(better);
  distance(sel(better)) = distance(better);
  sel = find(nearest<0);
  npart = floor(npart/2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nearest, distance] = find_nearest_partition(pnt1, pnt2, npart);

global fb;
if isempty(fb)
  fb = 0;
end

npnt1 = size(pnt1,1);
npnt2 = size(pnt2,1);

% this will contain the output
nearest  = zeros(npnt1, 1);
distance = zeros(npnt1, 1);

if npnt1==0
  return
end

minpnt1 = min(pnt1,1);
minpnt2 = min(pnt2,1);
maxpnt1 = max(pnt1,1);
maxpnt2 = max(pnt2,1);
pmin = min([minpnt1; minpnt2]) - eps;
pmax = max([maxpnt1; maxpnt2]) + eps;
dx = (pmax(1)-pmin(1))/npart;
dy = (pmax(2)-pmin(2))/npart;
dz = (pmax(3)-pmin(3))/npart;

% determine the lower boundaries of each partition along the x, y, and z-axis
limx = pmin(1) + (0:(npart-1)) * dx;
limy = pmin(2) + (0:(npart-1)) * dy;
limz = pmin(3) + (0:(npart-1)) * dz;

% determine the lower boundaries of each of the N^3 partitions
[X, Y, Z] = ndgrid(limx, limy, limz);
partlim = [X(:) Y(:) Z(:)];

% determine for each vertex to which partition it belongs
binx = ceil((pnt1(:,1)- pmin(1))/dx);
biny = ceil((pnt1(:,2)- pmin(2))/dy);
binz = ceil((pnt1(:,3)- pmin(3))/dz);
ind1 = (binx-1)*npart^0 + (biny-1)*npart^1 +(binz-1)*npart^2 + 1;

binx = ceil((pnt2(:,1)- pmin(1))/dx);
biny = ceil((pnt2(:,2)- pmin(2))/dy);
binz = ceil((pnt2(:,3)- pmin(3))/dz);
ind2 = (binx-1)*npart^0 + (biny-1)*npart^1 +(binz-1)*npart^2 + 1;

% use the brute force approach within each partition
for p=1:(npart^3)
  sel1 = (ind1==p);
  sel2 = (ind2==p);
  nsel1 = sum(sel1);
  nsel2 = sum(sel2);
  if nsel1==0 || nsel2==0
    continue
  end
  pnt1s = pnt1(sel1, :);
  pnt2s = pnt2(sel2, :);
  [pnear, pdist] = find_nearest_brute_force(pnt1s, pnt2s);

  % determine the points that are sufficiently far from the partition edge
  seln = true(nsel1, 1);
  if npart>1
    if partlim(p,1)>pmin(1), seln = seln & (pdist < (pnt1s(:,1) - partlim(p,1))); end
    if partlim(p,1)>pmin(2), seln = seln & (pdist < (pnt1s(:,2) - partlim(p,2))); end
    if partlim(p,1)>pmin(3), seln = seln & (pdist < (pnt1s(:,3) - partlim(p,3))); end
    if partlim(p,1)<pmin(1), seln = seln & (pdist < (partlim(p,1)) + dx - pnt1s(:,1)); end
    if partlim(p,2)<pmin(2), seln = seln & (pdist < (partlim(p,2)) + dx - pnt1s(:,2)); end
    if partlim(p,3)<pmin(3), seln = seln & (pdist < (partlim(p,3)) + dx - pnt1s(:,3)); end
  end

  % the results have to be re-indexed
  dum1 = find(sel1);
  dum2 = find(sel2);
  nearest(dum1( seln)) =  dum2(pnear( seln));
  nearest(dum1(~seln)) = -dum2(pnear(~seln));  % negative means that it is not certain
  distance(dum1)       = pdist;
end

% handle the points that ly in empty target partitions
sel = (nearest==0);
if any(sel)
  if fb, fprintf('%d points in empty target partition\n', sum(sel)); end
  pnt1s = pnt1(sel, :);
  [pnear, pdist] = find_nearest_brute_force(pnt1s, pnt2);
  nearest(sel) = pnear;
  distance(sel) = pdist;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nearest, distance] = find_nearest_brute_force(pnt1, pnt2);
% implementation 1 -- brute force
npnt1 = size(pnt1,1);
npnt2 = size(pnt2,1);
nearest  = zeros(npnt1, 1);
distance = zeros(npnt1, 1);
if npnt1==0 || npnt2==0
  return
end
for i=1:npnt1
  % compute squared distance
  tmp = (pnt2(:,1) - pnt1(i,1)).^2 + (pnt2(:,2) - pnt1(i,2)).^2 + (pnt2(:,3) - pnt1(i,3)).^2;
  [distance(i), nearest(i)] = min(tmp);
end
distance = sqrt(distance);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotpnt(pnt, varargin)
x = pnt(:,1);
y = pnt(:,2);
z = pnt(:,3);
plot3(x, y, z, varargin{:});

