function anno_list  = load_ann_data(imgdir,mask_dir)
%anno_list  = load_ann_data(imgdir,mask_dir)
%INPUT:
%   IMGDIR:     the directory contains the training images.
%   MASK_DIR:   the directory contains mask data, the mask data is also
%   stored in image format. 
%       Notes:  1) Mask image should have the same name as the
%   image name and is a gray image.
%               2) A mask image could have multiple object
%   in it, each object has a different value as its mask.
%               3) zeros value is background
%OUTPUT:
%   ANNO_LIST:  A 2D structure list which has two fields: {'img','mask'}
% Liming Wang, Jan 2008
% 
anno_list   = [];
[path_list,fname,file_list] = get_file_list(imgdir,{'png','jpg','bmp'});
for ff=1:length(path_list)
    img = imread(path_list(ff).name);
    mask_file   = fullfile(mask_dir,fname(ff).name);
    mask_img=imread(mask_file);
    if(size(mask_img,3)>1)
        error('mask image should be gray image');
    end
    [mvalue,m,n] = unique(mask_img(:));
    mvalue  = mvalue(find(mvalue>0));
    nb_mask = length(mvalue);
    for mm=1:nb_mask
        anno_list(ff,mm).img    = img;
        anno_list(ff,mm).mask   = (mask_img==mvalue(mm));
    end
end
