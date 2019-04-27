 


function r = NY8x8()
            clear
% %% 实验结果
            [expDisEvolution_3g, ... %分布变化
             expAccEvolution_3g, ... %累积数变化
             exp8x8list, ...         %原始数据   
             stateList] = ...        %64态标注
      DistributionEvol();
            [expMarkovOrig_3g, ...   % 马尔科夫矩阵 ，求和为64
             expMarkovAsym_3g, ...   % 实验豆矩阵
             expLoop3_3g] = ...      % 实验的圈
      StateTrans();
      save('..\o\exp8x8')
%% 理论结果
% 参数
        wlogit=0.0166; Lambda=1/wlogit;  repeat= 1000;   % dou(repeat)不对
% 理论分布3g*(8x2,64)、马尔科夫、支付矩阵、豆矩阵
             [theg3_Nash, ...    %Nash 均衡
              the3g_M64x64,  ... % 马尔科夫矩阵 ，求和为64
              the3g_v64,  ...    % 稳态64态之分布，求和为2 
              the3g_8x2_fromMarkov, ... % 稳态8+8态之分布
              g3_PayoffMatrix, ...   %支付矩阵 
              theg3_DouA, ...        % 理论豆矩阵
              theN_Dou] = ...        % 理论豆数量 （E4000vsT0）
        getTheoDisMark(Lambda,repeat,wlogit);
% 理论crossover 理论图  累积线、脉冲线
             [theg3_p16_acc16_1000, ...         % 32列=16溶度+15累积
              theg3_p16_acc16_lastround] =  ... %第1000轮结果 
        plotTheoCrossover(Lambda,repeat,wlogit); 
        save('..\o\the8x8') 
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Aacc Macc_ij2mn absSum] = w_markov_t_2csv(s)
absSum=[]; Macc=zeros(64); Aacc=zeros(64); Macc_mn2ij = zeros(64);Macc_ij2mn = zeros(64);
        for t=1:999
            Mij2mn = zeros(64); Mmn2ij = zeros(64); Aij2mn = zeros(64);
        for i=1:8
            for j=1:8
                for m=1:8
                    for n=1:8
                        a=find(stateList==i*10+j);
                        b=find(stateList==m*10+n);
                        Mij2mn(a,b) = s(t,i)*s(t,8+j)*s(t+1,m)*s(t+1,8+n);
                        Mmn2ij(a,b) = s(t,m)*s(t,8+n)*s(t+1,i)*s(t+1,8+j);
                        Aij2mn(a,b) = Mij2mn(a,b) - Mmn2ij(a,b);
                    end
                end
            end
        end
            Macc_ij2mn=Macc_ij2mn+Mij2mn;
            Macc_mn2ij=Macc_mn2ij+Mmn2ij;
            Aacc=Aacc+Aij2mn;
            absSum=[absSum; t sum(sum(abs(Macc_ij2mn))) sum(sum(abs(Aij2mn))) sum(sum(abs(Aacc)))];
%             markov_t_2csv = strcat('.\o\Aij2mn',num2str(2000+t),'.csv')
%             csvwrite(markov_t_2csv, Aij2mn);
%             Aacc_t_2csv = strcat('.\o\Flux\Aacc',num2str(2000+t),'.csv');
%             csvwrite(Aacc_t_2csv, Aacc);
%             Aacc_t_2csv = strcat('.\o\Flux\Macc',num2str(2000+t),'.csv');
%             csvwrite(Aacc_t_2csv, Macc);
        end



end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% \subsection{理论脉冲/交叉图}
%% \subsubsection{plotTheoCrossover.m}
%\begin{verbatim}
%C:\Users\Think\Desktop\新建文件夹 (3)\新建文件夹 (2)\plotK20190408.m
function [r3g_32_1000 r32 g3_PayoffMatrix] = plotTheoCrossover(Lambda,repeat,wlogit)
clf
Para = [2 1; 3 2; 4 2]; 
     r32=[];       r3g_32_1000=[];  g3_PayoffMatrix=[];
%      wlogit=0.02; Lambda=50; repeat =1000;  
     subjectsNumber = 12;
    for Pa=1:3

    % 定下参数   Lambda=50 dt=0.02
    %         r = logit_dyn_0909(payoff88(Para(Pa,1),Para(Pa,2)),Lambda,totalStep);
    %         r = logit_dyn_090A(payoff88(Para(Pa,1),Para(Pa,2)),Lambda,totalStep);
             P_Matrix = payoff88(Para(Pa,1),Para(Pa,2));
                 g3_PayoffMatrix = [g3_PayoffMatrix; P_Matrix];
                 
                 pq2x8 = [0.125*ones(1,8);0.125*ones(1,8)];
%                  seed1=rand(8);
%                  pq2x8 = [seed1(1,:)/sum(seed1(1,:));seed1(2,:)/sum(seed1(2,:))];
                 
             r = logit_dyn_090B20190408(P_Matrix,Lambda,repeat,wlogit,pq2x8);
                r3g_32_1000=[r3g_32_1000;r];  
                Accu_P1=r(:,17:24)*subjectsNumber;
                Accu_P2=r(:,25:32)*subjectsNumber;
        %     Accu_P1=r(:,17-16:24-16)*subjectsNumber;
        %     Accu_P2=r(:,25-16:32-16)*subjectsNumber;
                subFigId = 1+(Pa-1)*2;
                subplot(1,6, subFigId);plot(Accu_P1,'linewidth',2);title(strcat('T-X: ',num2str(Pa))) 
                    legend('1','2','3','4','5','6','7','8','Location','northwest');
                    xlim([0,600]);ylim([0,3200]); axis square; grid on
                        if subFigId ~= 1; set(gca,'ytick',[]); end
                        if subFigId ~= 6;  legend off; end ; set(gca,'xtick',[]);
                    %xlabel('Period','FontSize',15), ylabel('Accumulated Frequency','FontSize',15)
                subplot(1,6, subFigId+1);plot(Accu_P2,'linewidth',2);title(strcat('Y:  ',num2str(Pa))) 
                    legend('1','2','3','4','5','6','7','8','Location','eastoutside');
                    xlim([0,600]);ylim([0,3200]); axis square;  grid on
%                     xlabel('Period','FontSize',15) %, ylabel('Accumulated Frequency')
                         if subFigId+1 ~= 1; set(gca,'ytick',[]); end; set(gca,'xtick',[]);
                         legend off;
        r32 =[r32; r(repeat,:) Para(Pa,:) Lambda wlogit repeat]; 
    end
    
                            set(gcf,'papersize',[20 3],'paperposition',[3,3,20,3]);hold on; 
                            saveas(gcf,strcat('..\o\Theo600-',num2str(Lambda),'.png'))
end 

function anan=logit_dyn_090B20190408(A,Lambda,repeat,wlogit,pq2x8)  
                    %  pq2x8初始态
                    % 
%%logit_dyn_0909(payoff88(2,1),6,100)  Pa=6;Lambda=0.48;totalStep=100;logit_dyn_090B(payoff88(Para(Pa,1),Para(Pa,2)),Lambda,totalStep,0.01);
%%logit_dyn_090B(payoff88(2,1),6,100)
%%anan=[p1-8 q9-16 p_sum17-24 q_sum25-32];

pay_a=A/6;
pay_b=-A'/6;
%%
%
%初始
% % p=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125];
% % q=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125];

p=pq2x8(1,:);
q=pq2x8(2,:);

Ua=zeros(1,8);
Ub=zeros(1,8);

p_sum=zeros(1,8);
q_sum=zeros(1,8); 

anan=[];

    for ri=1:repeat
        for i=1:8
            Ua(i)=sum(q.*pay_a(i,:));
            Ub(i)=sum(p.*pay_b(i,:));	
        end
        p_sum=p_sum+p;
        q_sum=q_sum+q;		

        c_a=exp(Lambda*Ua);
        c_b=exp(Lambda*Ub);

    %     p=c_a./sum(c_a)*0.1 + p.*0.9;
    %     q=c_b./sum(c_b)*0.1 + q.*0.9;
        p=c_a./sum(c_a)*wlogit + p.*(1-wlogit);
        q=c_b./sum(c_b)*wlogit + q.*(1-wlogit);
% %% 20190426 离散化 开始
%         P=zeros(1,8);Q=zeros(1,8); 
%         a=clock;a1=a(5)*a(6)*1000;
%               for Ts=1:100 
%                 for k=1:mod(a1,100); seed=rand(1,2); end
%                     indexp=1;for i=1:7; if seed(1)>sum(p(1:i)) & seed(1)<sum(p(1:i+1));indexp=i+1;end;end; P(indexp)=P(indexp)+1; 
%                     indexq=1;for i=1:7; if seed(2)>sum(q(1:i)) & seed(2)<sum(q(1:i+1));indexq=i+1;end;end; Q(indexq)=Q(indexq)+1; 
%               end
%           p=P/100 ;q=Q/100 ;
% %           p=P  ;q=Q  ;
%    %  离散化 结束
        
        anan=[anan;p q p_sum q_sum];
    end
end
 
% \end{verbatim}

%% \subsection{理论分布与旋涡}
%% \subsubsection{GenTheoMarkoW20190408.m}
% \begin{verbatim}
%D:\MATLAB\R2016a\bin\html\wzj20180131\code\GenTheoMarkoW20190408.m
% logit_dyn_090A modified from logit_dyn_0909
% from 
%     p=c_a./sum(c_a);
%     q=c_b./sum(c_b);
% to 
%     p=c_a./sum(c_a)*0.1 + p.*0.9;
%     q=c_b./sum(c_b)*0.1 + q.*0.9;
% 
% from % C:\Users\Think\Desktop\新建文件夹 (2)\logit_dyn_090A.m
% function anan=logit_dyn_090A(A,k,repeat) add w as parameter
% function anan=logit_dyn_090B(A,Lambda,repeat,wlogit)
% Using Markov generated by dynamics to evaluate distribution 
% 20180910 
% %         A = payoff88(2,1); Lambda=128; repeat=100;  wlogit=0.02; %6 
% %         Lambda=128; repeat=100;  wlogit=0.02; %6 
% fLatex4 =
% 
%     6.0000   21.0000   81.0000   24.0000   22.0000    5.3935    4.1846   54.4017    3.4923   67.4721    3.4923
%     6.0000   21.0000   84.0000   24.0000   22.0000   36.3772   19.1681   54.4017    3.4923  113.4394    3.4923
%     6.0000   21.0000   84.0000   82.0000   22.0000   36.3772    3.8361    3.0473    3.4923   46.7530    3.0473
%     6.0000   22.0000   52.0000   24.0000   64.0000   88.5423   74.1734   38.9879  124.8744  326.5779   38.9879
%     6.0000   22.0000   52.0000   54.0000   24.0000   88.5423    7.3861   40.4136   54.4017  190.7436    7.3861
%     6.0000   22.0000   54.0000   24.0000   64.0000   29.8293   40.4136   38.9879  124.8744  234.1052   29.8293
%     6.0000   22.0000   62.0000   24.0000   64.0000   89.6432   27.6091   38.9879  124.8744  281.1146   27.6091
%     6.0000   22.0000   62.0000   54.0000   24.0000   89.6432    3.5999   40.4136   54.4017  188.0583    3.5999



function [theg3_Nash g3_M64x64 g3_v64 g3_dis_8x2_from_Markov g3_PayoffMatrix g3_theDouA N_Dou] = getTheoDisMark(Lambda,repeat,wlogit)
Para = [2 1; 3 2; 4 2];  
        theg3_Nash=[];
        g3_M64x64=zeros(64,64,3);   g3_theDouA = zeros(64,64,3);  N_Dou =[];
        g3_v64=zeros(64,3);  g3_PayoffMatrix=zeros(8,8,3); 
        g3_dis_8x2_from_Markov=[];
        subjectsNumber = 12;
    for Pa=1:3
         A=payoff88(Para(Pa,1),Para(Pa,2));
         [AnnNash,BobNash]=bimatNY8x8(A,-A);
         theg3_Nash=[theg3_Nash;[1:8]' AnnNash' BobNash' Pa*ones(8,1)];
         [rM64x64, v64, dis_from_Markov]= GenTheoMarkoW20190408(A,Lambda,repeat,wlogit);
         g3_M64x64(:,:,Pa) = rM64x64;
         g3_v64(:,Pa) =v64;
         g3_dis_8x2_from_Markov = [g3_dis_8x2_from_Markov; dis_from_Markov]; 
         g3_PayoffMatrix(:,:,Pa) = A; 
             theM=rM64x64; 
                 tmp=[];theDou=[]; 
                 for i=1:64; 
                     tmp=[tmp;v64(i)*theM(i,:)*12000];
                 end;
             theDou=[theDou;tmp];
             theDouA=round(theDou-theDou');
         g3_theDouA(:,:,Pa) = theDouA;
         N_Dou = [N_Dou;sum(sum(abs(theDouA)))];
    end
    
end

function [rM64x64 v64 dis_from_Markov]= GenTheoMarkoW20190408(A,Lambda,repeat,wlogit)
% repeat=round(1/wlogit);
% %         A = payoff88(2,1); Lambda=128; repeat=100;  wlogit=0.02; %6
        rM64x64=State_State_MarkovElement(A,Lambda,repeat,wlogit);
        v64 = 1/64 * ones(1,64) * rM64x64^10000000;
        V=zeros(8);for i = 1:8; V(i,:)= v64((i-1)*8+1:(i-1)*8+8);end
%  Stationary distribution on [X8 ; Y8] strategy 
        display 'Markov - Stationary distribution on [X8 ; Y8] strategy '
        dis_from_Markov = [1:8; sum(V'); sum(V)]'
   
        [a b]=eig(rM64x64'); 
        cc = [1:64; a(:,1)'/sum(a(:,1)); v64]'; % 检查步骤
end

function r = ExpeAndContiModelData()
r=[ ...
0.707	0.0513		0.842470367	0.02536562
0.1703	0.1858		0.087409584	0.239208516
0.0123	0.02		3.73225E-05	0.053085462
0.0113	0.6362		3.87235E-06	0.500618349
0.0388	0.0258		0.063488564	0.005633162
0.0158	0.0253		0.006587186	0.053123102
0.0252	0.0107		2.81262E-06	0.011789147
0.0192	0.0448		2.9182E-07	0.111176642
]; 
end


function rM64x64=State_State_MarkovElement(A,Lambda,repeat,wlogit)
%   A = payoff88(3,2); 
%   Lambda=128; repeat=100;  wlogit=0.001; %6
  M64x64=zeros(64); 
  listT=[];
  for I=1:8
      for J=1:8
          p=zeros(1,8);   q=zeros(1,8); 
          p(I)=1;q(J)=1; 
          anan=logit_dyn_090C20190408(A,Lambda,repeat,wlogit,p,q);
          anan=anan(repeat,:);
          listT=[listT; anan];
          MoneRow=[];
          for K=1:8
             MoneRow=[MoneRow anan(K)*anan(9:16)];
          end
          M64x64((I-1)*8+J,:) = MoneRow; 
      end
  end
  rM64x64 = M64x64;
  %% test c16 col1-16 =?= listT co;1-16? YES!! 
  c16=[];
  for j=1:64; a= []; b= []; 
      for i=1:8; 
          a = [a  sum(M64x64(j, (i-1)*8+1:(i-1)*8+8))];b= [b  sum(M64x64(j,i:8:64))];
      end; 
      c16=[c16; a b]; 
%       V=zeros(8);for i = 1:8; V(i,:)= v0((i-1)*8+1:(i-1)*8+8);end
  end

end


function anan=logit_dyn_090C20190408(A,Lambda,repeat,wlogit,p,q)
%%logit_dyn_0909(payoff88(2,1),6,100)
%%anan=[p1-8 q9-16 p_sum17-24 q_sum25-32];

pay_a=A/6;
pay_b=-A'/6;

%%
%
%初始
% p=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125];
% q=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125];

Ua=zeros(1,8);
Ub=zeros(1,8);

p_sum=zeros(1,8);
q_sum=zeros(1,8); 

anan=[];

    for ri=1:repeat
        for i=1:8
            Ua(i)=sum(q.*pay_a(i,:));
            Ub(i)=sum(p.*pay_b(i,:));	
        end
        p_sum=p_sum+p;
        q_sum=q_sum+q;		

        c_a=exp(Lambda*Ua);
        c_b=exp(Lambda*Ub);

    %     p=c_a./sum(c_a)*0.1 + p.*0.9;
    %     q=c_b./sum(c_b)*0.1 + q.*0.9;
        p=c_a./sum(c_a)*wlogit + p.*(1-wlogit);
        q=c_b./sum(c_b)*wlogit + q.*(1-wlogit);

        anan=[anan;p q p_sum q_sum];
    end
end
    
 

%% \subsubsection{TheoVortecInMarkovian.m}
% \begin{verbatim}
%C:\Users\Think\Desktop\wzj20180131\code\TheoVortecInMarkovian.m


function [M64x64 v64 distriInMarkov fLatex4]=VortexInTheoMarkovian(A,Lambda,repeat,wlogit)
% 20190425 这个函数的概念错了，它用了 1000 个repeat 后的Markovian来计算
% 计算的结果是，没有cycle 了。 因为结果不对，才发现，自己概念错了。 
% 
%                  A = payoff88(2,1)
%                  Lambda=98;  
%                  wlogit=0.01; 
%                  repeat= 2;  
%     [M64x64 v disMarkov]= GenTheoMarkoW(A,Lambda,repeat,wlogit);
    [M64x64 v64 distriInMarkov]= GenTheoMarkoW20190408(A,Lambda,repeat,wlogit);
                f=v64*12000;
                Para=A(8,7);
                constTran=5;
    T64 = zeros(64); for I=1:64; T64(I,:) = f(I)*M64x64(I,:);end

    TransMatrixOrig = T64;
    TransMatrixAsym = TransMatrixOrig - TransMatrixOrig'; 

% find 3 points vortex  
%                 Loop3 = f3vortex(TransMatrixAsym,stateList,Para,constTran);  
%                 Loop3_cleaned =  CleanedLoop3(Loop3,Para,constTran);
%                 ret3 = [ret3; Loop3_cleaned];
% find 4 points vortex       
statelist=stateList();ret4=[];
                Loop4 = f4vortex(TransMatrixAsym,statelist,Para,constTran);  
                Loop4_cleaned =  CleanedLoop4(Loop4,Para,constTran);
                ret4 = [ret4; Loop4_cleaned];
    if ~isempty(ret4) ==1
                    fLatex4 = [ret4(:,12) ret4(:,1:10)];
    %                 fLatex3 = [ret3(:,10) ret3(:,1:8)]
                    fLatex4 = sortrows(fLatex4,-11);
                    oRow=min(5,length(fLatex4(:,1)));
                    fLatex4 = [fLatex4(1:oRow,:); ones(1,11)]
    else
                fLatex4 = zeros(1,11);
    end
end


function ret4vortex = f4vortex(TransMatrixAsym,stateList,Para,constTran)
                Loop4=[];
    for I=1:64
        for J=1:64
            for K = 1:64
            for L = 1:64
                if TransMatrixAsym(I,J) > constTran & TransMatrixAsym(J,K) > constTran ...
                        & TransMatrixAsym(K,L) > constTran & TransMatrixAsym(L,I) > constTran 
                    Loop4=[Loop4; stateList(I) stateList(J) stateList(K) stateList(L) ...
                        TransMatrixAsym(I,J) TransMatrixAsym(J,K) TransMatrixAsym(K,L) TransMatrixAsym(L,I) ...
                        TransMatrixAsym(I,J)+TransMatrixAsym(J,K)+TransMatrixAsym(K,L)+TransMatrixAsym(L,I) ...
                        min([TransMatrixAsym(I,J) TransMatrixAsym(J,K) TransMatrixAsym(K,L) TransMatrixAsym(L,I)]) ...
                         999 Para constTran];
                end
            end
            end
        end
    end
                ret4vortex = Loop4;
end
 
function retCleanedLoop4 = CleanedLoop4(Loop4,Para,constTran)
Loop_cleaned = [];
    if  isempty(Loop4) == 0; 
            Loop_cleaned = [Loop4(1,1:9)  min(Loop4(1,5:8)) 999 Para constTran ];
            L6 = [Loop4(:,1:4) Loop4(:,1:9)];
            for I = 2:length(L6(:,1)) 
                temp=0;
                  for K=1:length(Loop_cleaned(:,1))
                      for J=2:5
                          if L6(I,J:J+3) == Loop_cleaned(K,1:4)
                              L6(I,1:8) = 999*ones(1,8); 
                              temp=1;
                          end
                      end
                  end
                 if temp==0; 
                     Loop_cleaned = [Loop_cleaned; L6(I,5:13) min(L6(I,9:12)) 999 Para constTran ];
                 end
            end
    end
 retCleanedLoop4 = Loop_cleaned;
end

function r=stateList()
r=[11;12;13;14;15;16;17;18;21;22;23;24;25;26;27;28; ...
    31;32;33;34;35;36;37;38;41;42;43;44;45;46;47;48; ...
    51;52;53;54;55;56;57;58;61;62;63;64;65;66;67;68; ...
    71;72;73;74;75;76;77;78;81;82;83;84;85;86;87;88];
end
% \end{verbatim}



%% \subsection{实验分布与旋涡} 
%% \subsubsection{Get8x8Data.m}
% \begin{verbatim}
% C:\Users\Think\Downloads\【批量下载】8x8(82).rar等3个文件\Get8x8Data.m
function [n8x8list,stateList,RPara] = Get8x8Data(Para)
% n8x8list = load('C:\Users\Think\Downloads\n8x8.csv');
n8x8list = load('..\i\n8x8.csv');
n8x8list(:,1) = n8x8list(:,1) * 100 - 8000000;

%构造 State_t0,State_tp1(+1,后一轮),State_tm1(-1,前一轮)
n8x8list(:,10) = n8x8list(:,6)*10 + n8x8list(:,7);
stateList=round(unique(n8x8list(:,10)));

n8x8list(:,11:12) = 999;
for L = 1:72000-1; n8x8list(L,11) = n8x8list(L+1,10);end
for L = 1+1:72000; n8x8list(L,12) = n8x8list(L-1,10);end

 
%分参数，每个参数有24000记录
RPara = n8x8list(find(n8x8list(:,9) == Para & n8x8list(:,5) == 1),:); 
% ------------------------------------------------- ^^ Ann data enough
end 
% \end{verbatim}
  
%% \subsubsection{StateTrans.m}
%\begin{verbatim}
%C:\Users\Think\Downloads\【批量下载】8x8(82).rar等3个文件\StateTrans.m
%% 计算转移矩阵 TransMatrixOrig， TransMatrixAsym
%   + 通过TransMatrixAsym中净转移次数 以constTran下限，求出三元圈 Loop3 
%   过滤Loop3 中的等价圈，求得 Loop_cleaned 圈数（含对应的态） 
function [TransMatrixOrig_3g TransMatrixA_3g fLatex]=StateTrans()
YiJiaDesign = [6 8 10];
  constTran = 5; 
ret = []; 
TransMatrixOrig_3g=zeros(64,64,3);
TransMatrixA_3g=zeros(64,64,3);
for ParaID=1:3
    Para = YiJiaDesign(ParaID);          
    [n8x8list,stateList,R] = Get8x8Data(Para);
                     % count 1st and 2nd half vortex  start                       
%                          R=R(find(R(:,3) > 500),:);                       
%                          R=R(find(R(:,3) < 501),:);  
                        R=sortrows(R,[1,2,3]);
                     % count 1st and 2nd half N-flux  end 
    TransMatrixOrig = zeros(64);
    for I = 1:64
            for J = 1:64
                TransMatrixOrig(I,J) = length(R(find(R(:,10) == stateList(I) & R(:,11) == stateList(J)),1)); 
            end
    end
                TransMatrixAsym = TransMatrixOrig - TransMatrixOrig';
                [sum(sum(abs(TransMatrixAsym))) sum(sum(TransMatrixAsym))]
TransMatrixOrig_3g(:,:,ParaID) = TransMatrixOrig;
TransMatrixA_3g(:,:,ParaID) = TransMatrixAsym;
              
                
                
                Loop3=[];
    for I=1:64
        for J=1:64
            for K = 1:64
                if TransMatrixAsym(I,J) > constTran & TransMatrixAsym(J,K) > constTran & TransMatrixAsym(K,I) > constTran 
                    Loop3=[Loop3; stateList(I) stateList(J) stateList(K) ...
                        TransMatrixAsym(I,J) TransMatrixAsym(J,K) TransMatrixAsym(K,I) ...
                        TransMatrixAsym(I,J)+TransMatrixAsym(J,K)+TransMatrixAsym(K,I) ...
                         999 Para constTran];
                end
            end
        end
    end


    Loop_cleaned = [Loop3(1,1:7)  min(Loop3(1,4:7)) 999 Para constTran ];
    L6 = [Loop3(:,1:3) Loop3(:,1:7)];
    for I = 2:length(L6(:,1)) 
        temp=0;
          for K=1:length(Loop_cleaned(:,1))
              for J=2:4
                  if L6(I,J:J+2) == Loop_cleaned(K,1:3)
                      L6(I,1:6) = 999*ones(1,6); 
                      temp=1;
                  end
              end
          end
         if temp==0; Loop_cleaned = [Loop_cleaned; L6(I,4:10) min(L6(I,7:9)) 999 Para constTran ];end
    end
    Loop4 = Loop_cleaned;
    ret = [ret; Loop_cleaned]
end
 
fLatex = [ret(:,10) ret(:,1:8)]
end
%\end{verbatim} 

%% \subsection{实验脉冲与交叉} 
%% \subsubsection{说明}

%\subsubsection{DistributionEvol.m }
%\begin{verbatim}
% C:\Users\Think\Downloads\【批量下载】8x8(82).rar等3个文件\DistributionEvol.m
%% 实验结果 

% C:\Users\Think\Downloads\【批量下载】8x8(82).rar等3个文件\DistributionEvol.m
%  
function [DisEvolution_3g,AccEvolution_3g,n8x8list,stateList]= DistributionEvol()
YiJiaDesign = [6 8 10];
ParaID=1;
DisEvolution_3g =[];
AccEvolution_3g =[];
clf;
for ParaID=1:3
    Para = YiJiaDesign(ParaID);
    [n8x8list,stateList,R] = Get8x8Data(Para);
%% 静态分布
Disoll = zeros(8,2); Dis1st = zeros(8,2); Dis2nd = zeros(8,2);Dis200Last = zeros(8,2);

    for I=1:8
        Disoll(I,1) = length(find(R(:,6)==I)); %T001 distribution
        Disoll(I,2) = length(find(R(:,7)==I)); %T002 distribution
        Dis1st(I,1) = length(find(R(:,6)==I & R(:,3) < 501 )); %T001 distribution
        Dis1st(I,2) = length(find(R(:,7)==I & R(:,3) < 501 )); %T002 distribution 
        Dis2nd(I,1) = length(find(R(:,6)==I & R(:,3) > 500 )); %T001 distribution
        Dis2nd(I,2) = length(find(R(:,7)==I & R(:,3) > 500 )); %T002 distribution 
        Dis200Last(I,1) = length(find(R(:,6)==I & R(:,3) > 800 ));
        Dis200Last(I,2) = length(find(R(:,7)==I & R(:,3) > 800 ));
    end
    DisEvolution_3g = [DisEvolution_3g; ones(8,1)*ParaID Disoll/12000 Dis1st/6000 Dis2nd/6000 Dis200Last/2400];
    
%% 累积分布-时间依赖
Accu_P1 = zeros(1000,8); %Accu(1,R(1,6))=1;
Accu_P2 = zeros(1000,8); %Accu(1,R(1,6))=1;
    for I = 1:1000
        for J=1:8
            Accu_P1(I,J) = length(find(R(:,6)==J & R(:,3) <= I));
            Accu_P2(I,J) = length(find(R(:,7)==J & R(:,3) <= I));
        end
    end
    AccEvolution_3g =[AccEvolution_3g; Accu_P1 Accu_P2 ones(1000,1)*ParaID];
% 安安想用中位数，屏蔽个例
% 中位数的算法有二种，
%  Algorithm 1 -- given t, for subject j and strategy j, calc 
%  p_{i,j}(t-25:t+25), then calc
%  x = median(p_{i,1:12}(t-25:t+25))

%  Algorithm 2 -- given t, for subject j and strategy j, calc 
%  p_{i,t} = median(p_{i,1:12}) -- result must be 0 or 1, then calc
%  p_{i,t} = mean(p_{i,t-25:t+25})
%
%     Accu_P1
%     Accu_P2

   subFigId = 1+(ParaID-1)*2;
    subplot(1,6,subFigId);plot(Accu_P1,'linewidth',2); title(strcat('E-X:',  num2str(ParaID))); 
%     legend('1','2','3','4','5','6','7','8','Location','northwest');
    xlim([0,600]);ylim([0,3200]);axis square
                         if subFigId ~= 1; set(gca,'ytick',[]); end
%     xlabel('Period','FontSize',15), ylabel('Accumulated Frequency','FontSize',15)
    subplot(1,6,subFigId+1);plot(Accu_P2,'linewidth',2); title(strcat('E-Y:',num2str(ParaID)))
%     legend('1','2','3','4','5','6','7','8','Location','EastOutside');
    xlim([0,600]);ylim([0,3200]);;axis square
                         if subFigId+1 ~= 1; set(gca,'ytick',[]); end
%     xlabel('Period','FontSize',15) %, ylabel('Accumulated Frequency')
    
end
                            set(gcf,'papersize',[17 3],'paperposition',[3,3,20,3]);hold on; 
%                             saveas(gcf,'D:\MATLAB\R2016a\bin\html\wzj20180131\Expe600a.png')
                            saveas(gcf,'..\o\Expe600.png')
end
% \end{verbatim} 
 

%% \subsection{共用函数} 

%% \subsubsection{payoff88.m}
%\begin{verbatim}
%C:\Users\Think\Desktop\新建文件夹 (3)\新建文件夹 (2)\payoff88.m
% function r=payoff88()
%   r = fpayoff88(2,1) %6
%       payoff88(3,2)  %8
%       payoff88(4,2)  %10 
% end


function P=payoff88(n,m)

P=zeros(8,8);

Stra=zeros(8,3);

for i=0:7
    tem=dec2bin(i,3);
    Stra(i+1,1)=str2num(tem(1));
    Stra(i+1,2)=str2num(tem(2));
    Stra(i+1,3)=str2num(tem(3));
end

situa=[];
situa_n=0;
for i=1:3
    for j=1:3
        if i==j
            continue
        end
        situa=[situa;i j];
        situa_n=situa_n+1;
    end
end

for i=1:8%for Ann %算Anan的收益
    for j=1:8 %for Bob
        for k=1:situa_n
            if Stra(i,situa(k,1))==0
                P(i,j)=P(i,j)+sign(situa(k,1)-situa(k,2))*m;
            else
                if Stra(j,situa(k,2))==0
                    P(i,j)=P(i,j)+1;
                else
                    P(i,j)=P(i,j)+sign(situa(k,1)-situa(k,2))*n;
                end
            end
        end
    end
end


end
%\end{verbatim}

%% \subsubsection{bimat.m} 

function [A,B,a,b,iterations,err,ms]=bimatNY8x8(M,N)
    C=M+N;[m,n]=size(C);u=[];v=[];a=[];b=[];count=0;ms=[];
    for i=1:m
        for j=1:n
            if (M(i,j)==max(M(:,j)) && N(i,j)==max(N(i,:)))
               count=count+1;u(count)=i;v(count)=j;a(count)=M(i,j);b(count)=N(i,j);
            end
        end
    end
    if count>0
        for i=1:count
            ms=[ms ' (A' int2str(u(i)) ',B' int2str(v(i)) ') with payoff to Ist player=' num2str(a(i)) ' and payoff to IInd player=' num2str(b(i)) ';'];
        end
        ms=['The bimatrix game has pure Nash equilibria as:-' ms];
    else
        ms=['The bimatrix game has no pure strategy Nash Equillibrium;'];
    end
    ms=[ms ' And one mixed strategy Nash Equilibrium is given in the solution matrix.'];
    H=-[zeros(m,m) C zeros(m,2);C' zeros(n,n+2);zeros(2,n+m+2)];
    f=[zeros(m+n,1);1;1];
    Aeq=[ones(1,m) zeros(1,n+2); zeros(1,m) ones(1,n) zeros(1,2)];
    beq=[1;1];b=zeros(m+n,1);
    A=[zeros(m,m) M -ones(m,1) zeros(m,1); N' zeros(n,n+1) -ones(n,1)];
    lb=[zeros(m+n,1);-inf;-inf];ub=[ones(m+n,1);inf;inf];options=optimset('Largescale','off','MaxIter',500);warning off all;
    [x,fval,exitflag,output,lambda]= quadprog(H,f,A,b,Aeq,beq,lb,ub);X=roundn((x(1:m,1))',-6);Y=roundn((x(m+1:m+n,1))',-6);f=roundn(fval,-6);
    switch exitflag
        case 1
            if abs(fval)<.05
                A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
                ms=[ms ' Also we mention that the mixed strategy solution is reasonably relevent!'];
            else
                A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
                ms=[ms 'Also we mention that the mixed strategy solution is not reasonably relevent!'];
            end
        case 4
            A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
             ms=[ms 'Also we mention that local minimizer was found!'];
        case 0
            A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
             ms=[ms 'Also we mention that the number of iterations is too large so the iteration scheme is not easily converging!'];
        case -2
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization problem is infeasible!'];
        case -3
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            msgn=['The optimization problem is unbounded!'];
        case -4
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization current search direction was not a descent direction. No further progress could be made.'];
        case -7
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['In the optimization process magnitude of search direction became too small. No further progress could be made.'];
        otherwise
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization problem has unexpected error!'];
    end
end   
     
 
 


 