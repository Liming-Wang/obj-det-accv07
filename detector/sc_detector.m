function [hypo_list,score_list, bbox_list,recog_result] = sc_detector(img,codebook,I_edge, para, verbose)
%SC_DETECTOR(img,codebook,I_edge,ratio, verbose) Object detection using shape context voting
%
% INPUT:
%   IMG:        img to detect object on
%   CODEBOOK:   contains the model object information
%   I_EDGE:     because shape context feature is extracted from edge map,
%   if the edge map of the input image could be computed ahead of time, it
%   will save a lot of computation time if you are using 'pb' detector
%   PARA:       related parameters, please refer to set_parameter.m
%   VERBOSE:    debug level control
%
% OUTPUT:
%   HYPO_LIST:  [#hypo x 2] detected hypotheses positions {x,y}
%   SCORE_LIST: [#hypo x 2] score for detected hypotheses
%   BBOX_LIST:  [#hypo x 4] boundary boxs
%   RECOG_RESULT:[1 x #scale] structure data, detail detection result, for
%   the purpose of debugging later
%
%
% related paper:
%   Object Detection Combining Recognition and Segmentation,
%    Liming Wang, Jianbo Shi, Gang Song, I-Fan Shen,
%    Eighth Asian Conference on Computer Vision (ACCV), 2007
%
%
%   Liming Wang, Jan 2008
%

if(~exist('verbose','var'))
    verbose = 0;
end

if(isempty(I_edge))
    if(isempty(img))
        error('Neither image nor edge data is provided in');
    else
        if(verbose>1)
            fprintf(1,'Begin edge detection...');
            tic;
        end
        para_sc     = para{1};
        para_fea    = para{2};
        para_vote   = para{3};
        I_edge  = compute_edge_pyramid(img, para_sc.detector, ...
            para_vote.min_height, para_fea.ratio);
        if(verbose>1)
            fprintf(1,'Edge detection: %f secs\n',toc);
        end
    end
end

[hypo_list, score_list, bbox_list,recog_result] = ...
    sc_detector_on_edge(I_edge, codebook, para, verbose);
hypo_list   = round(hypo_list);
bbox_list   = round(bbox_list);
