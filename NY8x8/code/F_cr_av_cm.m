%tem = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr/von_poker_6_cfr_cr.csv');
%cr_data{2} = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr_noise/von_poker_6_cfr_noise_cr.csv');
%cr_data{3} = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr_noise/von_poker_6_cfr_noise_1e-1_cr.csv');
dir1 = '/Users/sierra/IDWDS/code/NY8x8/output/open_spiel';
file = {'/cfr/','/cfr_noise/','/cfr_noise/'};
filename = {'von_poker_10_cfr_cr.csv','von_poker_10_cfr_noise_cr.csv','von_poker_10_cfr_noise_1e-1_cr.csv'};
noi = {'0','5e-2','1e-1'};
sgtitle('game 10')
for gameid = 1:3
    dir = strcat(dir1,strcat(file(gameid),filename(gameid)))
    cr_data = load(dir{1});
    cr_p{1} = cr_data((1:5000)*2-1,:);
    cr_p{2} = cr_data((1:5000)*2,:);
    for id = 1:2
        cm_p{id} = cumsum(cr_p{id});
        av_p{id} = cm_p{id}./((1:5000)'*ones(1,8));
        for i=1:8
            subplot(3,4,(gameid-1)*4+(id-1)*2+1)
            plot(cr_p{id}(1:500,i));
            if(gameid==1)
                title(strcat('player',strcat(num2str(id),' current policy')));
            end
            if(id==1)
                ylabel(strcat('noise = ',noi(gameid)))
            end
            hold on;
            subplot(3,4,(gameid-1)*4+(id-1)*2+2)
            plot(av_p{id}(1:500,i));
            if(gameid==1)
                title(strcat('player',strcat(num2str(id),' average policy')));
            end
            hold on;
        end
        for i =1:2
            subplot(3,4,(gameid-1)*4+(id-1)*2+i)
            axis([0,inf,0,1])
            legend('1','2','3','4','5','6','7','8')
        end
    end
end

