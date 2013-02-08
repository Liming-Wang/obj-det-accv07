function valid_hypo_idx = prune_by_area_overlapping(bbox_list,score_list, area_ratio_thresh)
% 
% 
% 
% 
% 
% Liming Wang, Jan 2008
% 
% % % % % % prune hypo by area overlapping % % % % % % % % %
if(~exist('area_ratio_thresh','var'))
    area_ratio_thresh   = 0.6;
end
nb_hypo = size(bbox_list,1);
p_flag=ones(nb_hypo, 1);
for hypo1   = 1:nb_hypo-1
    if(~p_flag(hypo1))      % if we have not processed hypo1
        continue;
    end
    for hypo2   = hypo1+1:nb_hypo   % check the remain hypos        
        if(~p_flag(hypo2))  % if hypo2 is in the valid list, check their overlapping condition
            continue;
        end
        [oratio1,oratio2,h1,h2]=computeOverlapArea(bbox_list(hypo1,:),bbox_list(hypo2,:));
        %   if(score_list(hypo1)>score_list(hypo2) && h1>h2 && oratio2>area_ratio_thresh)
        if(score_list(hypo1)>score_list(hypo2) && (oratio2>area_ratio_thresh)) % || oratio1>area_ratio_thresh))
            p_flag(hypo2)   = 0;
        end
        % if(score_list(hypo1)<score_list(hypo2) && h1<h2 && oratio1>area_ratio_thresh)
        if(score_list(hypo1)<score_list(hypo2) && (oratio1>area_ratio_thresh)) % || oratio2>area_ratio_thresh))
            p_flag(hypo1)   = 0;
            break;
        end
    end
end

valid_hypo_idx  = find(p_flag);
