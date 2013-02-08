%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %  This is a demo file to generate codebook of your own       % % % %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataroot    = getDataRoot;
img_dir = fullfile(dataroot,'train','images');
mask_dir= fullfile(dataroot,'train','mask');
codebook_file= fullfile(dataroot,'codebook','cb_test_new.mat');

% load default parameters
para_sc = set_parameter;
% override default model height
para_sc.model_height    = 150;

anno_data   = load_anno_data(img_dir,mask_dir);
codebook    = load_codebook(anno_data,para_sc);

save(codebook_file,'codebook');
