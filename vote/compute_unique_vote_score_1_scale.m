function [ recog_result ] = compute_unique_vote_score_1_scale( recog_result,para_fea)
%[ recog_result ] = compute_unique_vote_score_1_scale(recog_result,para_fea)
% 
% 
% Liming Wang, Jan 2008
%

score_list  = recog_result.score_list;
vote_record = recog_result.vote_record;

scoresK     = recog_result.scoresK;
scoresK_id  = recog_result.scoresK_id;
testpos     = recog_result.testpos;
valid_vote_idx=recog_result.valid_vote_idx;

nb_hypo     = length(vote_record);
nb_test     = size(testpos,1);

for hypo=1:nb_hypo
    voter_id        = vote_record(hypo).voter_id;
    v_id            = valid_vote_idx(voter_id);
    code_id         = scoresK_id(v_id);
    [test_id,K_id]  = ind2sub([nb_test,para_fea.K], v_id);
    
    [new_voter_idx,new_score,uni_test_id,uni_code_id]=one2one_match(test_id,code_id,1-scoresK(v_id)); 
    
    vote_record(hypo).voter_id  = voter_id(new_voter_idx);
    score_list(hypo)= new_score;
    
    %%%   old code  %%%
    %     nb_voter        = length(uni_test_id);
    %     new_voter_id    = zeros(nb_voter,1);
    %     new_score       = 0;
    %     for v_id=1:nb_voter
    %         u_id    = uni_test_id(v_id);
    %         match_id= find(test_id==u_id);
    %         [m_score,m_id]=max(scoresK(u_id,K_id(match_id)));
    %         % update voter_id
    %         new_voter_id(v_id)  = match_id(m_id);
    %         % update score
    %         new_score   = new_score+m_score;
    %     end
    %     vote_record(hypo).voter_id  = voter_id(new_voter_id);
    %     score_list(hypo)    = new_score;
    %%%
end

recog_result.vote_record  = vote_record;
recog_result.score_list   = score_list;
