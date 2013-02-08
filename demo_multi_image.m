%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo file to detect pedestrians in multi-images   % % % % % % %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% % =================================================================== % %
% % % % % % % % % % % The BEGINNING of the Demo File% % % % % % % % % % % %
% % =================================================================== % %

%%%%%%%%%%%%%%%%%%% edge prymid detection parameter %%%%%%%%%%%%%%%%%%%%%%%
ratio       = 1/1.2;  % <1.0 value, the factor to resize images

%%%%%%%%%%%%%%%%%%%%  debug parameter  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verbose     = 1;    % console output level: [0|1|2|3|4]
                    % 0: quiet
                    % 1: simple output with total detection time for each
                    %       image
                    % 2: output timing of each sub-routine
                    % 3: display detection results figure
                    % 4: display intermediate results figures;

%%%%%%%%%%%%%%%%%%%%  directory parameter   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % % % % % % % % % % % % % % % % %
dataroot    = getDataRoot;

img_dir     = fullfile(dataroot,'images');
edge_dir    = fullfile(dataroot,'edge');
out_dir     = fullfile(dataroot,'result');
if(~exist(out_dir,'dir'))
    mkdir(out_dir);
end
%%%%%%%%%%%%%%%%%%   output parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out_format  = 'mat';% output format:['mat' | 'txt']
detData     = [];   % used to record result data

result_file = fullfile(out_dir,['obj_det.',out_format]);
%%%%%%%%%%%%%%%%%%%%%%%%%% load codebook %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cb_file     = fullfile(dataroot,'codebook/cb_test_new.mat'); % cb_pb_height_150_bin_30.mat');
load(cb_file);

%%%%%%%%%%%%%%%%%%%%%%%%% MAIN parameter setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%
para    = set_parameter(codebook,ratio);
ratio   = para{2}.ratio;
%%%%%%%%%%%%%%%%%%%%%%%%% loop on images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[img_path, img_file, file_name]	= get_file_list(img_dir,{'png','jpg','bmp'});

img_cnt     = length(img_path);
for ff = 1:img_cnt
    fprintf(1,'processing %s\n',img_file(ff).name);
    edge_file   = fullfile(edge_dir,[file_name(ff).name,'.mat']);
    clear I_edge;
    % because edge computation is normally time consuming, we cache it for
    % future experiments
    if(~exist(edge_file,'file'))
        img = imread(img_path(ff).name);
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
    %%----- main detection function ------%%
    [hypo_list,score_list, bbox_list, recog_result] = sc_detector(img,codebook,I_edge, para, verbose);
    %%------------------------------------%%
    
    % display detection result and save it to image file
    
    fig = figure;
    ax1 = subplot('Position', [0,0,1,1]);
    display_hypo_rect(img, [], hypo_list, score_list, bbox_list, ax1);
    axis image;
    print(fig, '-dpng', fullfile(out_dir, [file_name(ff).name, '.png']));
    close(fig);
    detData(ff).imgname    = file_name(ff).name;
    detData(ff).hypo_list  = hypo_list;
    detData(ff).score_list = score_list;
    detData(ff).bbox_list  = bbox_list;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % save detection results to file  % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
if(strcmp(out_format,'mat'))
    save(result_file,'detData');
else
    fid = fopen(result_file,'w');
    if(fid==-1)
        fprintf(1,'Open file %s fails.\n', result_file);
        return;
    end
    for det_id=1:img_cnt
        nb_hypo = size(detData(det_id).hypo_list,1);
        for hypo=1:nb_hypo
            fprintf(fid,'%s\t%f\t%d\t%d\t%d\t%d\n',detData(det_id).imgname,...
                detData(det_id).score_list(hypo),...
                detData(det_id).bbox_list(hypo,1),...
                detData(det_id).bbox_list(hypo,2),...
                detData(det_id).bbox_list(hypo,3),...
                detData(det_id).bbox_list(hypo,4));
        end
    end
    fclose(fid);
end

% % =================================================================== % %
% % % % % % % % % % % The END of the Demo File% % % % % % % % % % % % % % %
% % =================================================================== % %



