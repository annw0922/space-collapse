`Regret` of not having chosen an action as the difference between the utility of that action and the utility of the
action we actually chose, with respect to the fixed choices of other players.

ex1. 在标准RPS中，player i选择rock而opponent选择paper。此时记
* $s_{i}$=rock, $s_{-i}=paper$
* utility $u(s_{i},s_{-i}) = -1$ 
* player i regrets not having played paper: $u(paper,paper)-u(rock,paper)=1$
* player i regrets not having played scissors: $u(scissors,paper)-u(rock,paper)=2$

`Regret matching:` an agents actions are
selected at random with a distribution that is proportional to positive regrets. . Positive regrets indicate the level of relative losses one has experienced for not having selected the action in the past.

`normalized positive regrets`: in ex1, player i has no regret for having chosen R but regrets 1 and 2 for not having chosen P and S. regret matching according to positive regrets is ($0,\frac{1}{3},\frac{2}{3}$)。

`cumulative regrets`: 假设接下来这一局我们选了S而对手选择R，那么这一轮我们对于RPS的regret分别为1,2,0。加上previous regrets(0,1,2), cumulative regrets就是1,3,2。那么对应的regret matching就是$(\frac{1}{6},\frac{3}{6},\frac{2}{6})$.


#### Minimize expected regret through self-play:
* initialize all cumulative regrets to 0
* for some number of iterations
    * compute a regret-matching strategy profile(如果全部非正数则uniform)
    * add the strategy profile to the strategy profile sum.
    * 根据strategy profile选择每个player的action
    * 计算每个player的regrets，并增加到player cumulative regrets.
* 返回average strategy profile(strategy profile sum divided by the number of iterations.)
