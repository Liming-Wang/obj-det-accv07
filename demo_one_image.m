%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo file to detect pedestrian in one single image% % % % % % % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dataroot    = getDataRoot;
img_file    = fullfile(dataroot,'images/FudanPed00001.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % % % load codebook % % % % % % % % % % % % % % % % % 
cb_file     = fullfile(dataroot,'codebook/cb_test_new.mat'); %cb_pb_height_150_bin_30.mat');

edge_file   = fullfile(dataroot, 'edge/FudanPed00001.mat');

load(cb_file);

verbose = 3;
% main detection funciton
img         = imread(img_file);
ratio       = 1/1.2;
para        = set_parameter(codebook,ratio);

if(~exist(edge_file,'file'))
    if(verbose>1)
        fprintf(1,'Begin edge detection...');
        tic;
    end
    I_edge  = compute_edge_pyramid(img, para{1}.detector,...
        para{3}.min_height, para{2}.ratio);
    if(verbose>1)
        fprintf(1,'Edge detection: %f secs\n',toc);
    end
    % save this file so that you do not need to compute edge again in
    % the later tuning
    save(edge_file,'I_edge','img','ratio');
else
    load(edge_file);
end

para{2}.ratio   = ratio;

[hypo_list,score_list, bbox_list] = sc_detector(img,codebook, I_edge , para, verbose);
% display detection results
display_hypo_rect(img, [], hypo_list, score_list, bbox_list);

