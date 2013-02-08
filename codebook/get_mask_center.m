function  center = get_mask_center(mask)
% center = get_mask_center(mask)
% 
% 
% Liming Wang, Jan 2008

[y, x] = find(mask);
% center(1) = mean(x);
% center(2) = mean(y);
center(1) = (min(x)+max(x))/2;
center(2) = (min(y)+max(y))/2;