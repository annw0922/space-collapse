%exp_plot
dir1 = '/Users/sierra/IDWDS/code/NY8x8/output/open_spiel';
file = {'/cfr/','/cfr_noise/','/cfr_noise/'};
filenamesum = 'von_poker_';
gameid_= {'6','8','10'}
filename = {'_cfr_exp.csv','_cfr_noise_exp.csv','_cfr_noise_1e-1_exp.csv'};
noi = {' 0',' 5e-2',' 1e-1'};
for gameid = 1:3
    for noid = 1:3
        dir = strcat(strcat(dir1,strcat(file{noid},filenamesum)),strcat(gameid_{gameid},filename{noid}));
        exptem = load(dir);
        subplot(3,3,(gameid-1)*3+noid);
        plot(log(exptem(1:1000)));
        axis([0,inf,-inf,0]);
        if (gameid==1)
            title(strcat('noise = ',noi(noid)));
        end
        if (noid==1)
            ylabel(strcat('game ',gameid_(gameid)));
        end
    end
end
sgtitle('exploitability(log)')