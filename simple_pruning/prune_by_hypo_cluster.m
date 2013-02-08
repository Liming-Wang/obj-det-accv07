function valid_hypo_idx=prune_by_hypo_cluster(hypo_list,score_list,scale_list,ratio_list, para_vote)
%valid_hypo_idx=prune_by_hypo_cluster(hypo_list,score_list,scale_list,
% ratio_list, para_vote) 
% 
% Liming Wang, Jan 2008
% 

% suppressing by local hypo maxima
scale_ratio_list= ratio_list(scale_list);

[dummy1, dummy2, valid_hypo_idx] = clusterHypo(hypo_list, score_list, scale_ratio_list, ...
    para_vote.elps_ab, para_vote.nb_iter);
