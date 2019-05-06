function [mb,nb,lb] = mybestblk(siz,k)
if nargin==1, k = 100; end % Default block size

%
% Find possible factors of siz that make good blocks
%

% Define acceptable block sizes
m = floor(k):-1:floor(min(ceil(siz(1)/10),ceil(k/2)));
n = floor(k):-1:floor(min(ceil(siz(2)/10),ceil(k/2)));
l = floor(k):-1:floor(min(ceil(siz(3)/10),ceil(k/2)));

% Choose that largest acceptable block that has the minimum padding.
[~,ndx] = min(ceil(siz(1)./m).*m-siz(1)); blk(1) = m(ndx);
[~,ndx] = min(ceil(siz(2)./n).*n-siz(2)); blk(2) = n(ndx);
[~,ndx] = min(ceil(siz(3)./l).*l-siz(3)); blk(3) = l(ndx);

if nargout == 3,
    mb = blk(1);
    nb = blk(2);
    lb = blk(3);
else
    mb = blk;
end