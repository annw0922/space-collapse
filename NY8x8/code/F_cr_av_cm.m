%cr_data = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr_noise/von_poker_10_cfr_noise_cr.csv');
%av_data = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr_noise/von_poker_10_cfr_noise_av.csv');
cr_data = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr/von_poker_10_cfr_cr.csv');
av_data = load('/Users/sierra/IDWDS/code/NY8x8/output/open_spiel/cfr/von_poker_10_cfr_av.csv');
cr_p{1} = cr_data((1:5000)*2-1,:);
cr_p{2} = cr_data((1:5000)*2,:);
av_p{1} = av_data((1:5000)*2-1,:);
av_p{2} = av_data((1:5000)*2,:);

for id = 1:2
    cm_p{id} = cumsum(cr_p{id});
    for i=1:8
        subplot(2,3,1+(id-1)*3)
        plot(cr_p{id}(1:500,i));
        hold on;
        subplot(2,3,2+(id-1)*3)
        plot(av_p{id}(1:500,i));
        hold on;
        subplot(2,3,3+(id-1)*3)
        plot(cm_p{id}(1:500,i));
        hold on;
    end
    for i =1:3
        subplot(2,3,i+(id-1)*3)
        legend('1','2','3','4','5','6','7','8')
    end
end
